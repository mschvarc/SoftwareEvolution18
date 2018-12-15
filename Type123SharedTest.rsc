module Type123SharedTest


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


public test bool testAstTypeRemoval(){
	statements = \if(\variable("myVarNameOriginal1", 2),\if(\number("2"),\break(),\break()));
	methodBlock =  \block([statements]);
	method1 = \method(wildcard(), "methodName1", [], [], methodBlock);
	
	modified = removeAstNamesAndTypes(method1);
		
	return modified != method1;
}

public test bool testAstNameRemoval(){	
	statements = \if(\variable("myVarNameOriginal", 2),\if(\number("2"),\break(),\break()));
	methodBlock =  \block([statements]);
	method1 = \method(wildcard(), "methodName1", [], [], methodBlock);
	
	modified = removeAstNamesAndTypes(method1);
		
	return modified != method1;
}

public test bool testNodeCountAtom(){
	statements = \break();
	return getNodeCountRec(statements) == 1;
}

public test bool testNodeCountNonEmpty(){
	statements = \if(\variable("myVarNameOriginal", 2),\if(\number("3"),\break(),\break()));
	return getNodeCountRec(statements) == 6;
}

public test bool testNodeListConversion(){
	statements = \if(\variable("myVarNameOriginal", 2),\if(\number("3"),\break(),\break()));
	listRes = convertAstToList(statements);
	return size(listRes) == 6;
}