module Type123Shared

import IO;
import List;
import Map;
import Node;
import Relation;
import Set;
import String;
import analysis::m3::AST;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::m3::Core;
import util::Math;
import util::Resources;

import DuplicationDefinitions;

bool DEBUG = false;
bool TRACE = false;


public DuplicationResults transformResultsForWeb(map[node, set[node]] input) {
	DuplicationResults result = [];
	
	for(key <- input) {
		list[loc] locations = [];
		for(srcNode <- input[key]) {
			//https://stackoverflow.com/questions/42650305/how-to-cast-data-of-type-value-to-other-type-of-values-in-rascal
			if(loc l := srcNode.src) {
				locations += l;
			}
		}
		result += <size(input[key]), locations>;
	}
	result = sort(result, duplicationResultComparator); 
	return result;
}

private bool duplicationResultComparator(DuplicationResult a, DuplicationResult b) {
	return a.duplicationCount > b.duplicationCount;
}

public map[node, set[node]] pruneSingletons(map[node, set[node]] input) {
	map[node, set[node]] result = ();
	for(n <- input){
		if(size(input[n]) > 1){
			result[n] = input[n];
		}
	}
	return result;
}

public Declaration removeAstNamesAndTypes(Declaration ast) {
	
	str overrideVarName = "var";
	str charName = "x";
	str numVal = "1";
	Type overrideType = wildcard();
	str metName = "met";
	
	ast = visit(ast) {
			case \variable(_, extraDimensions) => \variable(overrideVarName, extraDimensions)
			case \variable(_, extraDimensions, init) => \variable(overrideVarName, extraDimensions, init)
			case \cast(_, e) => \cast(overrideType, e)
			case \type(_) => \type(overrideType)
			case \simpleName(_) => \simpleName(charName)
			case \method(_, _, parameters, exceptions, impl) => \method(overrideType, metName, parameters, exceptions, impl)
		};
	return ast;
}

//debug print
public void printlnd(value input) {
	if(DEBUG){
		println(input);
	}
}

//trace print
public void printlnt(value input) {
	if(TRACE){
		println(input);
	}
}

public int getNodeCountRec(node input){
	int count = 0;
	visit(input) {
		case node n:  {count += 1;}
	}
	return count;
}

public list[node] convertAstToList(node ast){
	list[node] result = [];
	visit(ast) {
		case node n: {
			result += n;
		}
	}
	return result;
}


/**
Prunes results for same key of matching subtrees
A = subtree1
B = node containing A
Result: removes A, keeps B
*/
public map[node, set[node]] pruneDescendants(map[node, set[node]] input) {
	map[node, set[node]] output = ();
	
	for(key <- input){
		set[node] newSet = input[key];
		for(a <- input[key]){
			for(b <- input[key]){
				if( a == b){
					continue;
				}
				if( / a := b ){
					newSet = newSet - {a};
					printlnd("Pruned descendant: ");//<getNodeCountRec(a)> from <getNodeCountRec(b)>
				}
			}
		}
		output[key] = newSet;
	}
	return output;
}
