module UnitSize

import IO;

import List;
import String;
import Map;
 
import CommentStripper;

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import analysis::m3::AST;

public void USrun() {
	model = createM3FromEclipseProject(|project://smallsql0.21_src|);

	print("Avg Unit Size: ");
	println(calculateAverageUnitSizePerProject(calculateUnitSizeForProject(model)));
}


public real calculateAverageUnitSizePerProject(map[loc, int] unitSizes){
	int totalLOC = 0;
	int methodCount = size(unitSizes);
	
	for(<k,v> <- toRel(unitSizes)) {
		methodCount += 1;
		totalLOC += v;
	}
	
	println("methods: <methodCount>, total LOC: <totalLOC>, avg size: <totalLOC * 1.0 / methodCount>");
	
	return totalLOC * 1.0 / methodCount;
}

public map[loc, int] calculateUnitSizeForProject(M3 model) {
	set[loc] myMethods = methods(model);
	map[loc, int] resultMethodLoc = ();

	for(meth <- myMethods) { 
		resultMethodLoc[meth] = calculateUnitSize(meth);	
	}
	return resultMethodLoc;
}


public int calculateUnitSize(loc methodLoc){
	list[str] rawLines = readFileLines(methodLoc);
	int lineCount = size(stripEmptyLineAndComments(rawLines));	
	return lineCount;
}