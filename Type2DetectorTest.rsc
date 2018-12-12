module Type2DetectorTest

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

import Type;

import Type2Detector;

import lang::java::m3::TypeSymbol;


/* public test bool testTraverseMethodNoBranching(){	
	statements = \break();
	methodBlock =  \block([statements]);
	traverseMethodImpl(|project://softevo/src/tests/File1.java|,methodBlock);
	return true;
}


public test  bool testTraverseMethodSingleIf(){	
	statements = \if(\number("1"),\break());
	//vars1 =  \method(wildcard(), "testMethod", [\import("test")], [\number("123")], \block([inner]));
	methodBlock =  \block([statements]);
	traverseMethodImpl(|project://softevo/src/tests/File1.java|,methodBlock);
	return true;
}

public test bool testTraverseMethodNestedIf(){	
	statements = \if(\number("1"),\if(\number("2"),\break(),\break()));
	methodBlock =  \block([statements]);
	traverseMethodImpl(|project://softevo/src/tests/File1.java|,methodBlock);
	return true;
} */

/*public test bool testTraverseMethodNestedIfMet(){	
	statements = \if(\number("1"),\if(\number("2"),\break(),\break()));
	methodBlock =  \block([statements]);
	method1 = \method(wildcard(), "methodName1", [], [], methodBlock);
	traverseDeclaration(method1);
	
	//test = \return(\infix(\infix(\infix(\methodCall(false,\simpleName("x"),"getName",[]),"+",\characterLiteral("\'/\'")),"+",\simpleName("x")),"+",\simpleName("x")));
	
	return true;
}*/


public test bool testAstNameRemoval(){	
	statements = \if(\variable("myVarNameOriginal", 2),\if(\number("2"),\break(),\break()));
	methodBlock =  \block([statements]);
	method1 = \method(wildcard(), "methodName1", [], [], methodBlock);
	
	modified = removeAstNamesAndTypes(method1);
		
	return modified != method1;
}

/*
alias DuplicationResult = tuple[int duplicationCount, list[loc] fileLocations];
alias DuplicationResults = list[DuplicationResult];
alias DuplicateMap = map[node, set[node]];
*/

public test bool testAst1_subsumedAll_type2(){
	results = runType2detection(|project://softevo_testcase_ast_1|);
	return 
		size(results) == 1 && 
		size(results[0].fileLocations) == 4;
}

public test bool testAst2_subsumedOnlyMatching_type2(){
	results = runType2detection(|project://softevo_testcase_ast_2|);
	return 
		size(results) == 3 && 
		size(results[0].fileLocations) == 4 && 
		size(results[1].fileLocations) == 2 &&
		size(results[2].fileLocations) == 2;
}


public test bool createSetsOfExactMatchNodesTest_project3(){	
	ast = \class(toList(createAstsFromEclipseProject(|project://softevo_testcase_ast_3|, true)));
	res = createSetsOfExactMatchNodes(ast, 6);
	
	/*for(key <- res) {
		println(key);
		println("-------");
	}*/
	
	//println("<size(res)>");
	return size(res) == 3;

}

