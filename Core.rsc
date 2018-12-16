module Core

import DuplicationDefinitions;
import IO;
import List;
import Map;
import Node;
import Relation;
import Set;
import String;
import Type12Detector;
import Type123Shared;
import Type3Detector;
import analysis::m3::AST;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::m3::Core;
import util::Math;
import util::Resources;
import JsonWriter;

int CHUNK_SIZE = 6;

public void test1() {
	run(|project://softevo_testcase_ast_1|, TYPE_ONE(), |project://softevo/src/JSON.txt|);
}

public void test2() {
	run(|project://softevo_testcase_ast_1|, TYPE_TWO(), |project://test/src/JSON.txt|);
}

public void test3() {
	run(|project://softevo_testcase_ast_1|, TYPE_THREE(), |project://test/src/JSON.txt|);
}

public void run(loc projectLoc, DuplicationType dupType, loc resultLoc) {
	// generate the Abstract Syntax Tree for the given project
	set[Declaration] ast = createAstsFromEclipseProject(projectLoc, true);
	
	// Parse to get a more usable function
	node parsedAST = \class(toList(ast));
	//transform AST to remove types
	if(dupType == TYPE_TWO() || dupType == TYPE_THREE()) {
		parsedAST = removeAstNamesAndTypes(parsedAST);				
	}
	
	// count the total nodes in this AST
	int totalNodes = getNodeCountRec(parsedAST);
	
	// get the duplication and Clone Class data
	map[node, set[node]] dupResMap = calcDup(parsedAST, dupType);
	
	// use this information to calculate the duplication rate
	dupRatio = calcDupRatio(parsedAST, dupResMap);
	
	// store the clone class data in a JSON at the given location
	//dupResToJSON(resultLoc, transformResultsForWeb(dupResMap));
	
	// display the found duplication rate
	println("Duplication rate for this project: <dupRatio * 100>%");
	
	//display additional statistics 
	//additionalStats(parsedAST, dupResMap);
}

public map[node, set[node]] calcDup(node ast, DuplicationType dupType) {
	map[node, set[node]] dupResMap;

	switch (dupType) {
		case TYPE_ONE():
			dupResMap = runDuplicationCheckerType12(
				ast, TYPE_ONE()
			);
		case TYPE_TWO():
			dupResMap = runDuplicationCheckerType12(
				ast, TYPE_TWO()
			);
		case TYPE_THREE():
			dupResMap = runDuplicationCheckerType3(
				ast, CHUNK_SIZE
			);
	}
	
	return dupResMap;
}

public void additionalStats(node parsedAST, map[node, set[node]] dupRes){

	/*
	A report of cloning statistics showing at least the % of duplicated lines,
	number of clones, number of clone classes, biggest clone (in lines), biggest
	clone class, and example clones.
	*/
	
	int cloneCount = 0;
	int cloneClasses = size(dupRes);
	
	int biggestCloneSLOC = 0;
	node biggestCloneSLOCnode = getOneFrom(dupRes);;
	
	node biggestCloneClassSize = getOneFrom(dupRes);
	
	for(cloneClass <- dupRes) {
		cloneCount += size(dupRes[cloneClass]);
		
		for(node srcClone <- dupRes[cloneClass]){
			//find biggest SLOC clone
			if(loc l := srcClone.src) {
				if(l.end.line - l.begin.line > biggestCloneSLOC){
					biggestCloneSLOCnode = srcClone;
					biggestCloneSLOC = l.end.line - l.begin.line;
				}
			}
		}
		
		//find largest (in count) clone class
		if(size(dupRes[cloneClass]) > size(dupRes[biggestCloneClassSize])) {
			biggestCloneClassSize = cloneClass;
		}
	}
	str newline = "\n";
	println("Total clone count: <cloneCount> in <cloneClasses> clone classes");
	println("Biggest clone has <biggestCloneSLOC> SLOC, printed below: ");
	if(loc l := biggestCloneSLOCnode.src){
		println("<intercalate(newline,readFileLines(l))>");
	}
	
	
	println("----------");
	println("Biggest clone class by count of duplications has <size(dupRes[biggestCloneClassSize])> elements.");
	println("Example of clone below:");
	if(loc l := getOneFrom(dupRes[biggestCloneClassSize]).src){
		println("<intercalate(newline,readFileLines(l))>");
	}
	println("----------");

}

public real calcDupRatio(node parsedAST, map[node, set[node]] dupRes) {
	int cloneCount = 0;
	int totalNodes = getNodeCountRec(parsedAST);
	
	map[node, int] nodeBitmap = ();
	
	for (node cloneClassKey <- dupRes) {
		set[node] cloneClassSet = dupRes[cloneClassKey];		
		for (node clone <- cloneClassSet) {
			printlnd("Investigating <getNodeCountRec(clone)>  nodes in class set");
			visit(clone) {
				case node n: {
					if(n in nodeBitmap){
						nodeBitmap[n] += 1;
					} else {
						nodeBitmap[n] = 1;
					}
				}
			}
		}
	}
	
	for(item <- nodeBitmap){
		//for item to appear in bitmap, it must have been encountered at least once downstream
		//of a duplicate class
		if(nodeBitmap[item] >= 1){
			cloneCount += 1;
		}
	}
	
	println("duplicates = <cloneCount>; total = <totalNodes>");
	
	return cloneCount * 1.0 / totalNodes;
}
