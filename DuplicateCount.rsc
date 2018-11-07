module DuplicateCount

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

public void getDuplicateCount() {
	loc location = |project://smallsql0.21_src|;
	
	list[loc] projectFiles = [f | /file(f) := getProject(location), f.extension == "java"];
	findDuplicates(projectFiles);
	
}

public void findDuplicates(list[loc] projectFiles){	
	list[tuple[str lines, int startIndex, bool dup]] chunks = [];
	list[str] lines = [];
	
	int currLineIndex = 0;
	
	for(thisFile <- projectFiles) {
		for(chunk <- chunkify(thisFile)) {
			chunks += <chunk.lines, currLineIndex+chunk.startIndex, false>;
		}
		println(thisFile);
		currLineIndex += size(readFileLines(thisFile));
	}
	
	list[bool] duplicateIndicator = [];
	for(x <- [0..currLineIndex]) {
		duplicateIndicator += false;
	}
	
	for(int itemMainIndex <- [0..size(chunks)]) {
	if(chunks[itemMainIndex].dup) continue;
		for(int itemComparedIndex <- [(itemMainIndex+1)..size(chunks)]){
			if(chunks[itemComparedIndex].dup) continue;		
		
			if(chunks[itemMainIndex].lines == chunks[itemComparedIndex].lines){
				chunks[itemMainIndex].dup = true;
				for(thisIndex <- [0..6]) {
					duplicateIndicator[chunks[itemMainIndex].startIndex + thisIndex] = true;
				}
				chunks[itemComparedIndex].dup = true;
				for(thisIndex <- [0..6]) {
					duplicateIndicator[chunks[itemComparedIndex].startIndex + thisIndex] = true;
				}
			}
		}
	}
	int trueCount = size([x| x<-duplicateIndicator, x]);
	println("lines marked as dup: <trueCount>, total lines: <size(duplicateIndicator)>");
}


public list[tuple[str lines, int startIndex]] chunkify(loc file) {
	list[tuple[str lines, int index]] result = [];
	int currIndex = 0;

	list[str] lines = readFileLines(file);
	list[str] theseLines;
		
	while (currIndex + 5 < size(lines)) {
		theseLines = lines[currIndex .. (currIndex+6)];
		result += <stripSpaceAndConcat(theseLines), currIndex>;
		currIndex += 1;
	}
	
	return result;
}

public str stripSpaceAndConcat(list[str] lines) {
	str result = "";
	
	for (line <- lines) {
		if(trim(line) != "") result += trim(line);
	}
	
	return result;
}

public list[loc] getIndividualJavaFiles(loc project) {
	return [f | /file(f) := getProject(project), f.extension == "java"];
}


