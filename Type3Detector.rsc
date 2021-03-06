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
import Type123Shared;
import util::Math;

public void testProjectType3(){
	runType3detectionProject(|project://smallsql0.21_src|);
	//parseProject(|project://softevo|);
}



real type3subsumeThreshold = 0.8;
real type3equalityThreshold = 0.8;


public DuplicationResults runType3detectionProject(loc projectLoc){
	return transformResultsForWeb(runDuplicationCheckerProjectType3(projectLoc, 40));
}

public map[node, set[node]] runDuplicationCheckerProjectType3(loc projectLoc, int nodeSizeThreshold){
	//wrap everything to single class to force matching on whole project
	set[Declaration] ast = createAstsFromEclipseProject(projectLoc, true);
	return runDuplicationCheckerType3(\class(toList(ast)), nodeSizeThreshold);
}

public map[node, set[node]] runDuplicationCheckerType3(node ast, int nodeSizeThreshold){
	ast = removeAstNamesAndTypes(ast);
	map[node, set[node]] exactMatches = createSetsOfSimilarNodes(ast, nodeSizeThreshold);
	map[node, set[node]] subsumed = fixedPointSubsumeType3(exactMatches);
	subsumed = pruneSingletons(subsumed);
	
	printClasses(subsumed);
	
	return subsumed;
}


public map[node, set[node]] createSetsOfSimilarNodes(node ast, int nodeSizeThreshold){
	map[node, set[node]] results = ();
	map[node, int] nodeCountMap = ();
	
	visit(ast) {
		case node n : {
			//we need to do highlighting, can't do without SRC
			if("src" in getKeywordParameters(n) ){
				node cleared = unsetRec(n);
				
				printlnt("********");
				printlnt("processing: <cleared>");
				printlnt("********");
				
				int nodeCount = getNodeCountRec(cleared);
				nodeCountMap[cleared] = nodeCount;
				
				
				if(nodeCount >= nodeSizeThreshold && nodeCount <= 50 && size(results) <= 5000){ //TODO: finetune constant
					
					println("<size(results)>");
					if(size(results) == 0) {
						//add node as new unique key
						results[cleared] = {n};
					} else {
						
						node mostSimilarElement = unsetRec(getOneFrom(results));
						real mostSimilarRatio = treeSimilarity(mostSimilarElement, cleared);
						
						//traverse to find most similar node in map (if possible)
						for(comparedNode <- results){
							if(abs(nodeCountMap[comparedNode] - nodeCount) > 10){ //TODO: finetune constant
								continue;
							}
							real similarityRatio = treeSimilarity(comparedNode, cleared);
							if(similarityRatio > mostSimilarRatio) {
								mostSimilarElement = comparedNode;
								mostSimilarRatio = similarityRatio;
							}
						}
						
						//if above threshold, add to similar set
						if(mostSimilarRatio >= type3equalityThreshold) {
							printlnd("Adding item to existing set, simRatio <mostSimilarRatio>");
							printlnd("Appended to: <mostSimilarElement>");
							results[mostSimilarElement] += n;
						}
						//new unique element
						else {
							printlnd("Adding item to new set");
							results[cleared] = {n};
						}
					}
				}
			}
		}
	}
	
	printlnd("#################");
	printlnd("BEFORE de-duplication");
	printClasses(results);
	printlnd("#################");
	
	map[node, set[node]] nonDuplicatedResults = pruneSingletons(results);
	nonDuplicatedResults = pruneDescendants(nonDuplicatedResults);
	nonDuplicatedResults = pruneSingletons(nonDuplicatedResults);
	
	printlnd("#################");
	printlnd("After pruning, size 1 filter and set creation 1");
	printClasses(nonDuplicatedResults);
	printlnd("#################");
	
	printlnd("********");
	printlnd("size: <size(nonDuplicatedResults)>");
	for(n <- nonDuplicatedResults){
		printlnd("********");
		printlnd("<n>");
		printlnd("********");
	}
	printlnd("********");
	
	return nonDuplicatedResults;
}



public map[node, set[node]] fixedPointSubsumeType3(map[node, set[node]] input) {

	printlnd("original size before subsume <size(input)>");
	map[node, set[node]] output = subsumeType3(input);
	printlnd("subsumed first fixed point iteration: <size(output)>");
	
	while(input != output) {
		input = output;
		output = subsumeType3(output);
		printlnd("subsumed fixed point iteration: <size(output)>");
	}
	return output;
}

public map[node, set[node]] subsumeType3(DuplicateMap input) {
	
	map[node, set[node]] output = input; 
	
	for(outer <- input) {
		for(inner <- input) {
			if (outer == inner) {
				continue;
			}
			
			int outerCount = getNodeCountRec(outer);
			int innerCount = getNodeCountRec(inner);
			
			//GREATER THAN: bigger set can not be subsumed by smaller set
			//EQUAL: can be equal according to type 3 logic (change from type 1-2)
			//LESS THAN: only smaller set can be subsumed by bigger set
			if(outerCount > innerCount) {
				continue;
			}
			
			//assertions: outer <= inner
			
			outerPattern = getOneFrom(input[outer]);
			innerPattern = getOneFrom(input[inner]);
			
			typeThreeResult = typeThreeSubsume(input, outer, inner, output);
			output = typeThreeResult.output;
			if(typeThreeResult.shouldBreak){
				break;
			}
		}
	}
	output = pruneDescendants(output);
	
	printlnd("input size <size(input)>, output size <size(output)>");
	
	return output;
}


public tuple[DuplicateMap output, bool shouldBreak] typeThreeSubsume(DuplicateMap input, node outer, node inner, DuplicateMap output){
	bool shouldBreak = false;
	node outerUnset = unsetRec(outer);
	node innerUnset = unsetRec(inner);
	
	bool canSubsumeSimilarity = treeSimilarity(outerUnset, innerUnset) >= type3subsumeThreshold;
	
	if(canSubsumeSimilarity || ( / outerUnset := innerUnset) || canSubsumeSrcMatch(input, outer, inner)) {
		output = delete(output, outer);
		shouldBreak = true;
		printlnd("subsumed T3: <canSubsumeSimilarity>");
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



