module UnitSize

import IO;

import List;
import String;

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

public void main() {
	println(unitSize(createM3FromEclipseProject(|project://smallsql0.21_src|)));
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