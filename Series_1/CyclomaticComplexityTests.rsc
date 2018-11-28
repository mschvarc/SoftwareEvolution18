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

import SigRating;


public test bool testTraverseMethodNoBranching(){	
	statements = \break();
	methodBlock =  \block([statements]);
	result = traverseMethodImpl(|project://series1/src/tests/File1.java|,methodBlock);
	return result.linesOfCode == 12 && result.complexity == 1;
}


public test  bool testTraverseMethodSingleIf(){	
	statements = \if(\number("1"),\break());
	//vars1 =  \method(wildcard(), "testMethod", [\import("test")], [\number("123")], \block([inner]));
	methodBlock =  \block([statements]);
	result = traverseMethodImpl(|project://series1/src/tests/File1.java|,methodBlock);
	return result.linesOfCode == 12 && result.complexity == 2;
}

public test bool testTraverseMethodNestedIf(){	
	statements = \if(\number("1"),\if(\number("2"),\break(),\break()));
	methodBlock =  \block([statements]);
	result = traverseMethodImpl(|project://series1/src/tests/File1.java|,methodBlock);
	return result.linesOfCode == 12 && result.complexity == 3;
}


public test bool testPP(){
	result = calculateSIGCyclomaticComplexityMetrics(<0,25,0,0,100>);
	return result == PLUS_PLUS();
}


public test bool testP(){
	result = calculateSIGCyclomaticComplexityMetrics(<0,30,5,0,100>);
	return result == PLUS();
}


public test bool testZ(){
	result = calculateSIGCyclomaticComplexityMetrics(<0,40,10,0,100>);
	return result == ZERO();
}

public test bool testM(){
	result = calculateSIGCyclomaticComplexityMetrics(<0,50,15,5,100>);
	return result == MINUS();
}

public test bool testMM(){
	result = calculateSIGCyclomaticComplexityMetrics(<0,20,20,20,100>);
	return result == MINUS_MINUS();
}

