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

public node removeAstNamesAndTypes(node ast) {
	
	str overrideVarName = "var";
	str overrideParamName = "param";
	str charName = "x";
	str numVal = "1";
	Type overrideType = lang::java::jdt::m3::AST::float();
	str metName = "met";
	
	
	ast = visit(ast) {
			case \variable(_, extraDimensions) => \variable(overrideVarName, extraDimensions)
			case \variable(_, extraDimensions, init) => \variable(overrideVarName, extraDimensions, init)
			case \cast(_, e) => \cast(overrideType, e)
			case \type(_) => \type(overrideType)
			case Type _ => overrideType
			case \simpleName(_) => \simpleName(charName)
			case \method(_, _, parameters, exceptions, impl) => \method(overrideType, metName, parameters, exceptions, impl)
			case \parameter(_, _, c) => \parameter(overrideType, overrideParamName, c)
			
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


public bool canSubsumeSrcMatch(DuplicateMap input, node outer, node inner) {
	
	bool matched = true;
	bool matchedInner = false; 
	//TODO: add length
	for(node outerSrc <- input[outer]) {
		bool matchedInnerTest = any(innerSrc <- input[inner], 
			nodeToLoc(outerSrc.src).path == nodeToLoc(innerSrc.src).path);
		if(matchedInnerTest) {
			matchedInner = true;
		}
	}
	if(!matchedInner) {
		matched = false;
		printlnt("Failed canSubsumeSrcMatch");
		return false;
	}
	printlnt("canSubsumeSrcMatch suceeded");
	return matched;
}

public loc nodeToLoc(value v){
	if(loc l := v) {
		return l;
	}
	throw "fialed to extract location";
}

public void printClasses(map[node, set[node]] subsumed){
	for(key <- subsumed) {
		printlnd("-------");
		printlnd("<size(subsumed[key])> #");
		for(n <- subsumed[key]){
			printlnd("<n.src>");
		}
		printlnd("-------");
	}
}
