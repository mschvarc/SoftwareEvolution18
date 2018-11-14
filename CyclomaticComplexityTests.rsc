module CyclomaticComplexityTests

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

import CommentStripper;
import CyclomaticComplexity;

import lang::java::m3::TypeSymbol;


public bool testTraverseMethodNoBranching(){	
	statements = \break();
	methodBlock =  \block([statements]);
	result = traverseMethodImpl(|project://test2/src/tests/File1.java|,methodBlock);
	return result.linesOfCode == 12 && result.complexity == 1;
}


public bool testTraverseMethodSingleIf(){	
	statements = \if(\number("1"),\break());
	//vars1 =  \method(wildcard(), "testMethod", [\import("test")], [\number("123")], \block([inner]));
	methodBlock =  \block([statements]);
	result = traverseMethodImpl(|project://test2/src/tests/File1.java|,methodBlock);
	return result.linesOfCode == 12 && result.complexity == 2;
}

public bool testTraverseMethodNestedIf(){	
	statements = \if(\number("1"),\if(\number("2"),\break(),\break()));
	methodBlock =  \block([statements]);
	result = traverseMethodImpl(|project://test2/src/tests/File1.java|,methodBlock);
	return result.linesOfCode == 12 && result.complexity == 3;
}



public bool testPP(){
	result = calculateSIGCyclomaticComplexityMetrics(<25,0,0,100>);
	return result == PLUS_PLUS();
}


public bool testP(){
	result = calculateSIGCyclomaticComplexityMetrics(<30,5,0,100>);
	return result == PLUS();
}


public bool testZ(){
	result = calculateSIGCyclomaticComplexityMetrics(<40,10,0,100>);
	return result == ZERO();
}

public bool testM(){
	result = calculateSIGCyclomaticComplexityMetrics(<50,15,5,100>);
	return result == MINUS();
}

public bool testMM(){
	result = calculateSIGCyclomaticComplexityMetrics(<20,20,20,100>);
	return result == MINUS_MINUS();
}

