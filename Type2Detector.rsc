module Type2Detector


import IO;
import List;
import String;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import analysis::m3::AST;
import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import List;
import Set;
import Relation;
import Map;
import String;
import util::Math;
import util::Resources;
import List;
import String;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import analysis::m3::AST;
import Node;

/*

https://stackoverflow.com/questions/47555798/comparing-ast-nodes


*/

public void testProject(){
	runDuplicationCheckerProject(|project://smallsql0.21_src|, TYPE_TWO());
	//parseProject(|project://softevo|);
}

alias DuplicationResult = tuple[int duplicationCount, list[loc] fileLocations];
alias DuplicationResults = list[DuplicationResult];
alias DuplicateMap = map[node, set[node]];

data DuplicationType = TYPE_ONE() | TYPE_TWO() | TYPE_THREE();


public DuplicationResults runType2detection(loc projectLoc){
	return transformResultsForWeb(runDuplicationCheckerProject(projectLoc, TYPE_TWO()));
}

public DuplicationResults transformResultsForWeb(map[node, set[node]] input) {
	DuplicationResults result = [];
	
	for(key <- input) {
		list[loc] locations = [];
		for(srcNode <- input[key]) {
			println(srcNode.src);
			//https://stackoverflow.com/questions/42650305/how-to-cast-data-of-type-value-to-other-type-of-values-in-rascal
			if(loc l := srcNode.src) {
				locations += l;
			}
		}
		result += <size(input[key]), locations>;
	}
	result = sort(result, duplicationResultComparator); 
	return result;
}

private bool duplicationResultComparator(DuplicationResult a, DuplicationResult b) {
	return a.duplicationCount > b.duplicationCount;
}

public map[node, set[node]] runDuplicationCheckerProject(loc projectLoc, DuplicationType duplicationType){
	//wrap everything to single class to force matching on whole project
	set[Declaration] ast = createAstsFromEclipseProject(projectLoc, true);
	return runDuplicationChecker(\class(toList(ast)), duplicationType);
}



public map[node, set[node]] runDuplicationChecker(Declaration ast, DuplicationType duplicationType){
	if(duplicationType == TYPE_TWO() || duplicationType == TYPE_THREE()) {
		ast = removeAstNamesAndTypes(ast);
	}
	
	map[node, set[node]] exactMatches = createSetsOfExactMatchNodes(ast,  6);
	map[node, set[node]] subsumed = fixedPointSubsume(exactMatches, duplicationType);
	return subsumed;
}

public Declaration removeAstNamesAndTypes(Declaration ast) {
	
	str overrideVarName = "var";
	str charName = "x";
	str numVal = "1";
	Type overrideType = wildcard();
	str metName = "met";
	
	ast = visit(ast) {
			case \variable(_, extraDimensions) => \variable(overrideVarName, extraDimensions)
			case \variable(_, extraDimensions, init) => \variable(overrideVarName, extraDimensions, init)
			case \cast(_, e) => \cast(overrideType, e)
			case \type(_) => \type(overrideType)
			case \simpleName(_) => \simpleName(charName)
			case \method(_, _, parameters, exceptions, impl) => \method(overrideType, metName, parameters, exceptions, impl)
	 		//case \method(origType, _, parameters, exceptions) => \method(origType, metName, parameters, exceptions)
		};
	return ast;
}


public map[node, set[node]] createSetsOfExactMatchNodes(Declaration ast, int nodeSizeThreshold){
	map[node, set[node]] results = ();
	
	visit(ast) {
		case node n : {
			//we need to do highlighting, can't do without SRC
			if("src" in getKeywordParameters(n) ){
				node cleared = unsetRec(n);
				if(getNodeCountRec(cleared) >= nodeSizeThreshold){
					if(cleared in results) {
						results[cleared] += n;
					}
					else {
						results[cleared] = {n};
					}
				}
			}
		}
	}
	
	map[node, set[node]] nonDuplicatedResults = ();
	for(node n <- results){
		if(size(results[n]) > 1) {
			nonDuplicatedResults += (n : results[n]);
		}
	}	
	return nonDuplicatedResults;
}

public map[node, set[node]] fixedPointSubsume(map[node, set[node]] input, DuplicationType duplicationType) {

	println("original size before subsume <size(input)>");
	map[node, set[node]] output = subsume(input, duplicationType);
	println("subsumed first fixed point iteration: <size(output)>");
	
	while(input != output) {
		input = output;
		output = subsume(output, duplicationType);
		println("subsumed fixed point iteration: <size(output)>");
	}
	return output;
}

public map[node, set[node]] subsume(DuplicateMap input, DuplicationType duplicationType) {
	
	map[node, set[node]] output = input; 
	
	for(outer <- input) {
		for(inner <- input) {
			if (outer == inner) {
				continue;
			}
			
			int outerCount = getNodeCountRec(outer);
			int innerCount = getNodeCountRec(inner);
			
			//GREATER THAN: bigger set can not be subsumed by smaller set
			//EQUAL: can't be same size, different equivalence class
			//LESS THAN: only smaller set can be subsumed by bigger set
			if(outerCount >= innerCount) {
				continue;
			}
			
			//assertions: outer < inner
			
			outerPattern = getOneFrom(input[outer]);
			innerPattern = getOneFrom(input[inner]);
			
			//type 1 and 2 is exact match only
			if(duplicationType == TYPE_ONE() || duplicationType == TYPE_TWO()) {
				typeOneTwoResult = typeOneAndTwoSubsume(input, outer, inner, output);
				output = typeOneTwoResult.output;
				if(typeOneTwoResult.shouldBreak){
					break;
				}
			} 
			//similarity match type 3
			else if(duplicationType == TYPE_THREE()) {
				typeThreeResult = typeThreeSubsume(input, outer, inner, output);
				output = typeThreeResult.output;
				if(typeThreeResult.shouldBreak){
					break;
				}
			}
		}
	}
	
	println("input size <size(input)>, output size <size(output)>");
	
	return output;
}

public tuple[DuplicateMap output, bool shouldBreak] typeOneAndTwoSubsume(DuplicateMap input, node outer, node inner, DuplicateMap output){
	
	//if inner SUBSET outer:
	//remove inner from results
	//SEE: http://tutor.rascal-mpl.org/Rascal/Patterns/Abstract/Descendant/Descendant.html
	
	bool shouldBreak = false;
	
	if( / outer := inner) {
		//println("found subtree, outer <outerCount>  SS inner: <innerCount>, inspecting");
		
		//subsume only if all outer with src match inner with src (same file subsumption for entire class)
		bool canSubsume = true;
		for(outerSrc <- input[outer]){
			bool matchFoundInner = false;
			for(innerSrc <- input[inner]){
				if(/ outerSrc :=  innerSrc){
					matchFoundInner = true;
					shouldBreak = true;
				}
			}
			if(!matchFoundInner){
				canSubsume = false;
				shouldBreak = true;
			}
		}
		if(canSubsume) {
			//println("subsumed with SRC match");
			
			output = delete(output, outer);
			
			/*
			println("--------");
			println("--------");
			println((input[outer]));
			println("--------");
			println("LARGER");
			println("--------");
			println((input[inner]));
			println("--------");
			println("--------");
			
			*/
			shouldBreak = true; //this outer pattern is deleted, go to next one
		} 
	}	
	
	
	return <output, shouldBreak>;
}

public tuple[DuplicateMap output, bool shouldBreak] typeThreeSubsume(DuplicateMap input, node outer, node inner, DuplicateMap output){
	bool shouldBreak = false;
	
	return <output, shouldBreak>;
}

public int getNodeCountRec(node input){
	int count = 0;
	visit(input) {
		case node n:  {count += 1;}
	}
	return count;
}


