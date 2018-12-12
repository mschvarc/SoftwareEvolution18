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


public test bool testTraverseMethodNoBranching(){	
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
}


public test bool testThisProject() {
	parseProject(|project://softevo/|);
	return true;
}
