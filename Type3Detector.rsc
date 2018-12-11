module Type3Detector


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
	runDuplicationCheckerProject(|project://smallsql0.21_src|, TYPE_TWO());
	//parseProject(|project://softevo|);
}



real type3subsumeThreshold = 0.8;
real type3equalityThreshold = 0.8;


public DuplicationResults runType3detection(loc projectLoc){
	return transformResultsForWeb(runDuplicationCheckerProjectType3(projectLoc, TYPE_THREE()));
}

public map[node, set[node]] runDuplicationCheckerProjectType3(loc projectLoc, DuplicationType duplicationType, int nodeSizeThreshold){
	//wrap everything to single class to force matching on whole project
	set[Declaration] ast = createAstsFromEclipseProject(projectLoc, true);
	return runDuplicationCheckerType3(\class(toList(ast)), duplicationType);
}


public map[node, set[node]] runDuplicationCheckerType3(Declaration ast, DuplicationType duplicationType, int nodeSizeThreshold){
	ast = removeAstNamesAndTypes(ast);
	map[node, set[node]] exactMatches = createSetsOfSimilarNodes(ast, nodeSizeThreshold);
	map[node, set[node]] subsumed = fixedPointSubsume(exactMatches, duplicationType);
	return subsumed;
}



public map[node, set[node]] createSetsOfSimilarNodes(Declaration ast, int nodeSizeThreshold){
	map[node, set[node]] results = ();
	
	visit(ast) {
		case node n : {
			//we need to do highlighting, can't do without SRC
			if("src" in getKeywordParameters(n) ){
				node cleared = unsetRec(n);
				if(getNodeCountRec(cleared) >= nodeSizeThreshold){
					
					if(size(results) == 0) {
						//add node as new unique key
						results[cleared] = {n};
					} else {
						
						node mostSimilarElement = getOneFrom(results);
						real mostSimilarRatio = treeSimilarity(mostSimilarElement, n);
						
						//traverse to find most similar node in map (if possible)
						for(comparedNode <- results){
							real similarityRatio = treeSimilarity(comparedNode, n);
							if(similarityRatio > mostSimilarRatio) {
								mostSimilarElement = comparedNode;
								mostSimilarRatio = similarityRatio;
							}
						}
						
						//if above threshold, add to similar set
						if(mostSimilarRatio >= type3equalityThreshold) {
							results[cleared] += n;
						}
						//new unique element
						else {
							results[cleared] = {n};
						}
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
			
			typeThreeResult = typeThreeSubsume(input, outer, inner, output);
			output = typeThreeResult.output;
			if(typeThreeResult.shouldBreak){
				break;
			}
		}
	}
	
	println("input size <size(input)>, output size <size(output)>");
	
	return output;
}


public tuple[DuplicateMap output, bool shouldBreak] typeThreeSubsume(DuplicateMap input, node outer, node inner, DuplicateMap output){
	bool shouldBreak = false;
	bool canSubsume = treeSimilarity(outer, inner) >= type3subsumeThreshold;
	
	if(canSubsume) {
		output = delete(output, outer);
		shouldBreak = true;
	} 
	return <output, shouldBreak>;
}

public real treeSimilarity(node leftAst, node rightAst){

	/*
	From Clone Detection Using Abstract Syntax Trees

	Similarity = 2 x S / (2 x S + L + R)
	where:
	S = number of shared nodes
	L = number of different nodes in sub-tree 1
	R = number of different nodes in sub-tree 2
	*/
	
	list[node] leftList = convertAstToList(leftAst);
	list[node] rightList = convertAstToList(rightAst);
	list[node] intersection = leftList & rightList;
	
	int shared = size(intersection);
	int leftDifferent = 0;
	int rightDifferent = 0;
	
	for(node leftNode <- leftList){
		if(leftNode notin intersection){
			leftDifferent += 1;
		}
	}
	
	for(node rightNode <- rightList){
		if(rightNode notin intersection){
			rightDifferent += 1;
		}
	}
	
	
	return 2.0 * shared / (2.0 * shared + leftDifferent + rightDifferent);
}



