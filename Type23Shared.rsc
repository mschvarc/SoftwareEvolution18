module Type23Shared

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

//alias CloneReport = map[str, set[tuple[loc path, list[int] indices]]];
/*
alias DuplicationResult = tuple[int duplicationCount, list[loc] fileLocations];
alias DuplicationResults = list[DuplicationResult];
alias DuplicateMap = map[node, set[node]];
*/

/*
public CloneReport locToCloneReport(DuplicationResults results){
	CloneReport result = ();
	
	for(result <- results) {
		for(loc fileLocation <- result.fileLocations){
			list[str] lines = readFileLines(toLocation(fileLocation.uri)); //read entire file
			list[int] indices = [fileLocation.offset +  .. ];
			result[
			//TODO http://docs.rascal-mpl.org/unstable/Rascal/#Values-Location
		}
	}
	
	return result;
}*/


public DuplicationResults transformResultsForWeb(map[node, set[node]] input) {
	DuplicationResults result = [];
	
	for(key <- input) {
		list[loc] locations = [];
		for(srcNode <- input[key]) {
			println(srcNode.src);
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
