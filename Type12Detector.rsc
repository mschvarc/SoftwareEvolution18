module Type12Detector


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
import DuplicationDefinitions;
import Type23Shared;


public void testProject(){
	runDuplicationCheckerProjectType12(|project://smallsql0.21_src|, TYPE_TWO());
	//parseProject(|project://softevo|);
}

public void testProjectRatio(){
	//result = getRatio(|project://smallsql0.21_src|, TYPE_TWO());
	result = getRatio(|project://test|, TYPE_TWO());
	println(result.dupRatio);
}

public tuple[real dupRatio, DuplicationResults dupRes] getRatio(loc projectLoc, DuplicationType dupType) {
	set[Declaration] ast = createAstsFromEclipseProject(projectLoc, true);
	node parsedAST = \class(toList(ast));
	
	int totalNodes = getNodeCountRec(parsedAST);
	
	dupRes = runDuplicationCheckerType12(
				\class(toList(ast)), 
				dupType
			);
	
	dupRatio = calcDupRatio(totalNodes, dupRes);
	
	return <dupRatio, transformResultsForWeb(dupRes)>;
}

public real calcDupRatio(int total, map[node, set[node]] dupRes) {
	int cloneCount = 0;
	
	for (node cloneClassKey <- dupRes) {
		set[node] cloneClassSet = dupRes[cloneClassKey];
		for (node clone <- cloneClassSet) {
			cloneCount += getNodeCountRec(clone);
			println("Found <getNodeCountRec(clone)> cloned items");
		}
	}
	
	println("total = <total>");
	
	return cloneCount * 1.0 / total;
}

public DuplicationResults runType12detection(loc projectLoc){
	return transformResultsForWeb(runDuplicationCheckerProjectType12(projectLoc, TYPE_TWO()));
}


public map[node, set[node]] runDuplicationCheckerType12(Declaration ast, DuplicationType duplicationType){
	if(duplicationType == TYPE_TWO() || duplicationType == TYPE_THREE()) {
		ast = removeAstNamesAndTypes(ast);
	}
	
	map[node, set[node]] exactMatches = createSetsOfExactMatchNodes(ast,  6);
	map[node, set[node]] subsumed = fixedPointSubsume(exactMatches, duplicationType);
	return subsumed;
}

public map[node, set[node]] runDuplicationCheckerProjectType12(loc projectLoc, DuplicationType duplicationType){
	//wrap everything to single class to force matching on whole project
	set[Declaration] ast = createAstsFromEclipseProject(projectLoc, true);
	return runDuplicationCheckerType12(\class(toList(ast)), duplicationType);
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
			typeOneTwoResult = typeOneAndTwoSubsume(input, outer, inner, output);
			output = typeOneTwoResult.output;
			if(typeOneTwoResult.shouldBreak){
				break;
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




