module UnitSize

import IO;

import List;
import String;

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import analysis::m3::AST;

public void main() {
	model = createM3FromEclipseProject(|project://smallsql0.21_src|);

	print("Avg Unit Size: ");
	println(unitSize(model));
	
	print("Avg Unit Complexity: ");
	println(unitComp(model));
}

public real unitComp(M3 model) {
	myMethods = methods(model);

	complexityCount = 0;
	methodCount = 0;
	
	for(meth <- myMethods) {
		complexityCount += singleUnitComp(meth, model);
		
		methodCount += 1;
	}
	
	return complexityCount * 1.0 / methodCount;
}

public int singleUnitComp(loc meth, M3 model) {
	absSynTree = getMethodASTEclipse(meth, model);
	return 0;
}

public real unitSize(M3 model) {
	myMethods = methods(model);

	int methodCount = 0;
	int lineCount = 0;

	for(meth <- myMethods) { 
		methodCount += 1;
		
		lineCount += size(readFileLines(meth));
	}
	
	return lineCount * 1.0 / methodCount;
}
/**
private int countLinesInMethod(str methStr) {
	return size(findAll(methStr, "\n")) + 1;
}*/