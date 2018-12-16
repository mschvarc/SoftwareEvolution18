module Type12DetectorTest

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
import Type123Shared;

import Type;

import Type12Detector;

import lang::java::m3::TypeSymbol;

/*===========*/


public test bool testAst1_subsumedAll_type1(){
	results = runType1detectionProject(|project://softevo_testcase_ast_1|);
	println(results);
	return 
		size(results) == 3 && 
		size(results[0].fileLocations) == 4 && 
		size(results[1].fileLocations) == 2 &&
		size(results[2].fileLocations) == 2;
}

public test bool testAst2_subsumedOnlyMatching_type1(){
	results = runType1detectionProject(|project://softevo_testcase_ast_2|);
	return 
		size(results) == 2 && 
		size(results[0].fileLocations) == 2 && 
		size(results[1].fileLocations) == 2;
}

/*===========*/


public test bool testAst1_subsumedAll_type2(){
	results = runType2detectionProject(|project://softevo_testcase_ast_1|);
	return 
		size(results) == 1 && 
		size(results[0].fileLocations) == 4;
}

public test bool testAst2_subsumedOnlyMatching_type2(){
	results = runType2detectionProject(|project://softevo_testcase_ast_2|);
	return 
		size(results) == 2 && 
		size(results[0].fileLocations) == 2 && 
		size(results[1].fileLocations) == 2;
}

/*===========*/

public test bool createSetsOfExactMatchNodesTest_project3_empty(){	
	ast = \class(toList(createAstsFromEclipseProject(|project://softevo_testcase_ast_3|, true)));
	res = createSetsOfExactMatchNodes(ast, 6);
	println("<size(res)>");
	return size(res) == 0;
}

public test bool createSetsOfExactMatchNodesTest_project3_transformAST(){	
	ast = \class(toList(createAstsFromEclipseProject(|project://softevo_testcase_ast_3|, true)));
	ast = removeAstNamesAndTypes(ast);
	res = createSetsOfExactMatchNodes(ast, 6);
	println("<size(res)>");
	return size(res) == 3;
}

public test bool testAst3_subsumedOnlyMatching_type2(){
	results = runType2detectionProject(|project://softevo_testcase_ast_3|);
	println("<results>");
	return 
		size(results) == 1 && 
		size(results[0].fileLocations) == 2;
}

