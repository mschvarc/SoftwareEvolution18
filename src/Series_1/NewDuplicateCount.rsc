module NewDuplicateCount

import CommentStripper;
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

import SigRating;

alias DuplicateResult = tuple[real ratio, int lineCount, int duplicateLines];

/**
* Classifies the duplication inside a project according to the SIG methodology. 
* @param project project location
* @return SIG rating and duplication ratio
*/
public tuple[SIG_INDEX rating, DuplicateResult result] getSigDuplication(loc project) {
	result = getDupRatio(getProjFiles(project));
	return <classifyDuplication(result.ratio), result>;
}

/**
* Classifies duplication ratio according to the SIG methodology.
* @param percentage
* @return SIG rating
*/
public SIG_INDEX classifyDuplication(real percentage){
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

/**
 *  function getDupRatio
 *	@param 	projFiles 	-> locations of files to be analysed
 *	@return real	-> float in range [0,1) indicating amount of duplication in the project
 *
 * This function calculates the duplicate code chunk ratio in a given project. 
 * It does this by going over each line of code in every Java file in the project and extracting each chunk. 
 * Whenever we get a chunk, we store it in a set. If we have already encountered a chunk, 
 * this means we found a chunk of duplicate code. To keep track of this, 
 * we add the Chunk Size to the counter. If the last chunk we checked already was a duplicate, 
 * this means the current duplicate chunk is overlapped by the last one. 
 * To account for this, we only add 1 to the duplicate lines counter. 
 * At the end of each file, we get the size of the list containing all the LOC in that file 
 * and add it to a counter so that we know the total amount of code lines in the project. 
 * The end result is the Number of Duplicate Lines divided by the Total Amount of Lines.
 */

public DuplicateResult getDupRatio(list[loc] projFiles) 
{
	// window size
	int CHUNK_SIZE = 6;
	
	// set up some counters and keep-track-of-ers
	int dupLOCCount = 0;
	int totalLOC = 0;
	
	map[str, set[tuple[loc location, int startIndex]]] chunks = ();
	map[loc, int] fileToLocCount = ();
	
	// loop over all of the files in the project
	for (currFile <- projFiles) 
	{
		// get the LOC from this file (no Whitespace or Comments)
		list[str] currLines = stripEmptyLineAndComments(readFileLines(currFile));
		
		// loop over all of the chunks in this file
		for (int index <- [0..(size(currLines)-CHUNK_SIZE+1)])
		{
			// get each individual chunk as a concatenated string
			str currChunk = getChunk(currLines[index..index + CHUNK_SIZE]);
			
			if( currChunk in chunks) {
				//append
				chunks[currChunk] += <currFile, index>;
			} else {
				//init entry
				chunks[currChunk] = {<currFile, index>};
			}
			
			
		}
		fileToLocCount[currFile] = size(currLines);
		totalLOC += size(currLines);
	}
	
	//	map[str, set[tuple[loc location, int startIndex]]] chunks = ();
	map[loc, list[bool]] fileLineBitIndex = ();
    
    //go over the results, ignore entries with only 1 item
	for(stringChunk <- chunks) {
	
		if(size(chunks[stringChunk]) <= 1){
			continue;
		} 
		
		for(<loc location, int startIndex> <- chunks[stringChunk]) {
			
			//init location file 
			if(location notin fileLineBitIndex) {
				list[bool] bitIndex = [];
				for(int i <- [0.. (fileToLocCount[location])]) {
					bitIndex += false;
				}
				fileLineBitIndex[location] = bitIndex;
			}
			
			for(int index <- [startIndex .. (startIndex + CHUNK_SIZE)]){
				fileLineBitIndex[location][index] = true;
				//println("<stringChunk> setting <location> @ <index> to true");
			}
		}
	}
	
	//count actual duplicate LOC
	for(loc key <- fileLineBitIndex) {
		for(bit <- fileLineBitIndex[key]) {
			if(bit) {
				dupLOCCount += 1;
			}
		}
	}	
	
	// testing purposes: output the found lines of code and other stats
	//println("Total Lines of Code: <totalLOC>, number of duplicate lines: <dupLOCCount>");
	
	// we have parsed all of the LOC in all of the files, return the calculated result
	return <dupLOCCount * 1.0 / totalLOC, totalLOC, dupLOCCount >;
}

private str getChunk(list[str] lines) {
	result = "";
	for (s <- lines) { result += s; }
	return result;
}


private list[loc] getProjFiles(loc project) {
	return [f | /file(f) := getProject(project), f.extension == "java"];
}
