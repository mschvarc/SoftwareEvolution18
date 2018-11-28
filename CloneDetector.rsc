module CloneDetector

import CommentStripperAndIndexer;
import IO;
import List;
import Map;
import Relation;
import Set;
import String;
import analysis::m3::AST;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::m3::Core;
import util::Math;
import util::Resources;
import Map;

// custom object and constant definitions
alias CloneReport = map[str, set[tuple[loc path, list[int] indices]]];
int CHUNK_SIZE = 6;

/*public bool type1(str chunk1, str chunk2) {
	return chunk1 == chunk2;
}*/

public CloneReport test1() {
	return genCRforFile(|project://test/src/tests/CloneTest1.java|);
}
public CloneReport test2() {
	return genCRforFile(|project://test/src/tests/CloneTest2.java|);
}

public CloneReport genCRforProject(loc proj) {
	// instantiate result variable
	CloneReport totalCR = ();

	// get all of the project files in the given project
	list[loc] projFiles = getProjFiles(proj);
	
	// loop over each file
	for (thisFile <- projFiles) {
		// get the chunk information for this file
		thisFileCR = genCRforFile(thisFile);
		
		// merge the new information with the old
		totalCR = mergeCRs(thisFileCR, totalCR);
	}
	// return the final Clone Report
	return totalCR;
}

public CloneReport genCRforFile(loc file) {
	// init variables 
	CloneReport result = ();
	str chunkKey;
	
	// get the stripped and indexed lines of the given file
	list[tuple[int,str]] indexedLines = stripAndIndex(readFileLines(file));
	
	// if we don't have enough lines to form a chunk, we have nothing to do here
	if (size(indexedLines) < CHUNK_SIZE) return result;
	
	// the first chunk is the first five indexed lines with a dummy tuple in front,
	// this will get converted to a valid chunk in the first step of the loop
	list[tuple[int,str]] currChunk = [<0,"0">] + slice(indexedLines, 0, 5);
	
	// loop over the rest of the lines
	for (i <- [5..size(indexedLines)]) {
		// update the current chunk with the next line
		currChunk = nextChunk(currChunk, indexedLines[i]);
		
		// convert the different lines into one string (serves as key in the result set)
		<chunkKey, chunkIndices> = getChunkKeyAndIndices(currChunk);
				
		// check if the current chunk was encountered already
		if (chunkKey in result) {
			// add the file and range into the existing entry
			result[chunkKey] += {<file, chunkIndices>};
		} else {
			result[chunkKey] = {<file, chunkIndices>};
		}
	}
	
	// return completed result
	return result;
}

public list[tuple[int,str]] nextChunk(list[tuple[int,str]] curr, tuple[int,str] next) {
	return slice(curr+next,1,CHUNK_SIZE);
}

public tuple[str,list[int]] getChunkKeyAndIndices(list[tuple[int,str]] chunk) {
	tuple[str key, list[int] range] result = <"", []>;
	for(<thisIndex,thisLine> <- chunk) {
		result.key += thisLine;
		result.range += [thisIndex];
	}
	return result;
}

/**
 *	Merge two Clone Reports, first parameter should be the smaller of the two
 *  @param CloneReport, CloneReport
 *  @return CloneReport
 */
public CloneReport mergeCRs(CloneReport newFile, CloneReport oldFile) {
	for (key <- newFile) {
		if (key in oldFile) {
			oldFile[key] = oldFile[key] + newFile[key];
		} else {
			oldFile[key] = newFile[key];
		}
	}
	return oldFile;
}

private list[loc] getProjFiles(loc project) {
	return [f | /file(f) := getProject(project), f.extension == "java"];
}