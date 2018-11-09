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

import CommentStripper;
import CyclomaticComplexity;

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



