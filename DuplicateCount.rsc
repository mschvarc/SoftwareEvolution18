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

import SigRating;


public SIG_INDEX calculateDuplicationSigRatingProject(loc project) {

	result = findDuplicates(getIndividualJavaFiles(project));
	real percentage = result.duplicateLines * 1.0 / result.lineCount;

	if(percentage < 0.03){
		return PLUS_PLUS();
	} else if(percentage >= 0.03 && percentage < 0.05) {
		return PLUS();
	} else if(percentage >= 0.05 && percentage < 0.10) {
		return ZERO();
	} else if(percentage >= 0.10 && percentage < 0.20) {
		return MINUS();
	} else {
		return MINUS_MINUS();
	}

}


public tuple[int lineCount, int duplicateLines] findDuplicates(list[loc] projectFiles){	
	list[tuple[str lines, int startIndex, bool dup]] chunks = [];
	list[str] lines = [];
	
	int currLineIndex = 0;
	
	for(thisFile <- projectFiles) {
		for(chunk <- chunkify(thisFile)) {
			chunks += <chunk.lines, currLineIndex+chunk.startIndex, false>;
		}
		currentLength = size(readFileLinesStripWhitespace(thisFile));
		currLineIndex += currentLength;
		}
	
	list[bool] duplicateIndicator = [];
	for(x <- [0..currLineIndex]) {
		duplicateIndicator += false;
	}
	
	println("Chunks: <size(chunks)>");
	
	int chunksSize = size(chunks);
	
	for(int itemMainIndex <- [0..chunksSize]) {
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
		if(itemMainIndex % 200 == 0) {
			println("processed <itemMainIndex> outer chunks / <chunksSize>");
		}
	}
	int duplicateCount = size([x| x<-duplicateIndicator, x]);
	println("lines marked as dup: <duplicateCount>, total lines: <size(duplicateIndicator)>");
	
	return <size(duplicateIndicator),duplicateCount>;
}


public list[tuple[str lines, int startIndex]] chunkify(loc file) {
	list[tuple[str lines, int index]] result = [];
	int currIndex = 0;

	list[str] lines = readFileLinesStripWhitespace(file);
	list[str] theseLines;
	
	int linesSize = size(lines);
		
	while (currIndex + 5 < linesSize) {
		theseLines = lines[currIndex .. (currIndex+6)];
		result += <trimAndConcatLines(theseLines), currIndex>;
		currIndex += 1;
	}
	
	return result;
}

public list[str] readFileLinesStripWhitespace(loc file){
	//TODO: implement whitespace stripping logic relevant to duplicate detection here
	//TODO: strip blank only lines? 
	//TODO: strip (multiline)comments too?
	return readFileLines(file);
}

public str trimAndConcatLines(list[str] lines) {
	str result = "";
	for (line <- lines) {
		result += trim(line);
		//TODO: remove leading tab characters
	}
	return result;
}

public list[loc] getIndividualJavaFiles(loc project) {
	return [f | /file(f) := getProject(project), f.extension == "java"];
}

