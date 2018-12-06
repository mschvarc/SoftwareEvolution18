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
	parseProject(|project://smallsql0.21_src|);
	//parseProject(|project://softevo|);
}

alias DuplicationResult = tuple[int duplicationCount, list[loc] fileLocations];
alias DuplicationResults = list[DuplicationResult];


public DuplicationResults runType2detection(loc projectLoc){
	return transformResultsForWeb(parseProject(projectLoc));
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

public map[node, set[node]] parseProject(loc projectLoc){
	//wrap everything to single class to force matching on whole project
	set[Declaration] ast = createAstsFromEclipseProject(projectLoc, true);
	return traverseDeclaration(\class(toList(ast)));
}



public void traverseProject(set[Declaration] ast){	
	for(Declaration d <- ast) {		
		traverseDeclaration(d);
	}
}


public map[node, set[node]] traverseDeclaration(Declaration ast){

	str overrideVarName = "var";
	str charName = "x";
	str numVal = "1";
	Type overrideType = wildcard();
	str metName = "met";
	
	//TODO: generalize: Type 1: no change, type 2: change, type 3: ???
	ast = visit(ast) {
		case \variable(_, extraDimensions) => \variable(overrideVarName, extraDimensions)
		case \variable(_, extraDimensions, init) => \variable(overrideVarName, extraDimensions, init)
		case \cast(_, e) => \cast(overrideType, e)
		case \type(_) => \type(overrideType)
		case \simpleName(_) => \simpleName(charName)
		//\method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions, Statement impl)
		//case \method(_, _, parameters, exceptions, impl) => \method(overrideType, metName, parameters, exceptions, impl)
 		//case methodSrc:\method(ret, _, parameters, exceptions) => \method(ret, metName, parameters, exceptions)
	};
	
	return makeSets(ast);
}


public map[node, set[node]] makeSets(Declaration ast){
	map[node, set[node]] results = ();
	int nodeSizeThreshold = 6;
	
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
	
	nonDuplicatedResults = fixedPointSubsume(nonDuplicatedResults);
	
	return nonDuplicatedResults;
}

public map[node, set[node]] fixedPointSubsume(map[node, set[node]] input) {

	println("original size before subsume <size(input)>");
	map[node, set[node]] output = subsume(input);
	println("subsumed first fixed point iteration: <size(output)>");
	
	while(input != output) {
		input = output;
		output = subsume(output);
		println("subsumed fixed point iteration: <size(output)>");
	}
	return output;
}

public map[node, set[node]] subsume(map[node, set[node]] input) {
	
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
			
			//if inner SUBSET outer:
			//remove inner from results
			//SEE: http://tutor.rascal-mpl.org/Rascal/Patterns/Abstract/Descendant/Descendant.html
			outerPattern = getOneFrom(input[outer]);
			innerPattern = getOneFrom(input[inner]);
			
			if( / outer := inner) {
				//println("found subtree, outer <outerCount>  SS inner: <innerCount>, inspecting");
				
				//subsume only if all outer with src match inner with src (same file subsumption for entire class)
				bool canSubsume = true;
				for(outerSrc <- input[outer]){
					bool matchFoundInner = false;
					for(innerSrc <- input[inner]){
						if(/ outerSrc :=  innerSrc){
							matchFoundInner = true;
							break;
						}
					}
					if(!matchFoundInner){
						canSubsume = false;
						break;
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
					break; //this outer pattern is deleted, go to next one
				} 
			} 
		}
	}
	
	println("input size <size(input)>, output size <size(output)>");
	
	return output;
}



public int getNodeCountRec(node input){
	int count = 0;
	visit(input) {
		case node n:  {count += 1;}
	}
	return count;
}


