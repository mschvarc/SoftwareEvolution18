module Core

import DuplicationDefinitions;
import IO;
import List;
import Map;
import Node;
import Relation;
import Set;
import String;
import Type12Detector;
import Type23Shared;
import Type3Detector;
import analysis::m3::AST;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::m3::Core;
import util::Math;
import util::Resources;

int CHUNK_SIZE = 6;

public void test1() {
	run(|project://test|, TYPE_ONE(), |project://test/src/JSON.txt|);
}

public void test2() {
	run(|project://test|, TYPE_TWO(), |project://test/src/JSON.txt|);
}

public void test3() {
	run(|project://test|, TYPE_THREE(), |project://test/src/JSON.txt|);
}

public void run(loc projectLoc, DuplicationType dupType, loc resultLoc) {
	// generate the Abstract Syntax Tree for the given project
	set[Declaration] ast = createAstsFromEclipseProject(projectLoc, true);
	
	// Parse to get a more usable function
	node parsedAST = \class(toList(ast));
	
	// count the total nodes in this AST
	int totalNodes = getNodeCountRec(parsedAST);
	
	// get the duplication and Clone Class data
	map[node, set[node]] dupResMap = calcDup(parsedAST, dupType);
	
	// use this information to calculate the duplication rate
	dupRatio = calcDupRatio(totalNodes, dupResMap);
	
	// store the clone class data in a JSON at the given location
	dupResToJSON(resultLoc, transformResultsForWeb(dupResMap));
	
	// display the found duplication rate
	println("Duplication rate for this project: <dupRatio>");
}

public map[node, set[node]] calcDup(node ast, DuplicationType dupType) {
	map[node, set[node]] dupResMap;

	switch (dupType) {
		case TYPE_ONE():
			dupResMap = runDuplicationCheckerType12(
				ast, TYPE_ONE()
			);
		case TYPE_TWO():
			dupResMap = runDuplicationCheckerType12(
				ast, TYPE_TWO()
			);
		case TYPE_THREE():
			dupResMap = runDuplicationCheckerType3(
				ast, TYPE_THREE(), CHUNK_SIZE
			);
	}
	
	return dupResMap;
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
