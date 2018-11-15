module DuplicateCountTest

import DuplicateCount;


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


public test bool testTwoDuplicateFiles50percent(){
	list[loc] locs = [|project://test/src/tests/File1.java|,|project://test/src/tests/File2.java|];
	result = findDuplicates(locs);
	return result.lineCount == 24 && result.duplicateLines == 14;
}

public test bool testDuplicatesSameFileTwice(){
	list[loc] locs = [|project://test/src/tests/File1.java|,|project://test/src/tests/File1.java|];
	result = findDuplicates(locs);
	return result.lineCount == 24 && result.duplicateLines == 24;
}

public test bool testNoDuplicateFiles(){
	list[loc] locs = [|project://test/src/tests/File1.java|,|project://test/src/tests/File3.java|];
	result = findDuplicates(locs);
	return result.lineCount == 24 && result.duplicateLines == 0;
}


public test bool testChunkifyFile12lines(){
	chunks = chunkify(|project://test/src/tests/File1.java|);
	return size(chunks) == 7;
}

//TODO: add back test
public void getDuplicateCountSmallSql() {
	loc location = |project://smallsql0.21_src|;
	
	list[loc] projectFiles = [f | /file(f) := getProject(location), f.extension == "java"];
	findDuplicates(projectFiles);
}

