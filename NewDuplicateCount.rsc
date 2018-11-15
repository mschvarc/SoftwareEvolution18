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

import SigRating;

public tuple[SIG_INDEX rating, real percentage] getSigDuplication(loc project) {
	result = getDupRatioProject(project);
	return <classifyDuplication(result.ratio), result.ratio>;
}

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

public  tuple[real ratio, int lineCount, int duplicateLines] getDupRatioProject(loc proj) {
	return getDupRatio(getProjFiles(proj));
}


/**
 *  function getDupRatio
 *	@param 	loc 	-> location of project to be analysed
 *	@return real	-> float in range [0,1) indicating amount of duplication in the project
 *
 *	This function calculates the duplicate code chunk ratio in a given project. It does this by going over each line of code in every Java file in the project and extracting each chunk. Whenever we get a chunk, we store it in a set. If we have already encountered a chunk, this means we found a chunk of duplicate code. To keep track of this, we add the Chunk Size to the counter. If the last chunk we checked already was a duplicate, this means the current duplicate chunk is overlapped by the last one. To account for this, we only add 1 to the duplicate lines counter. At the end of each file, we get the size of the list containing all the LOC in that file and add it to a counter so that we know the total amount of code lines in the project. The end result is the Number of Duplicate Lines divided by the Total Amount of Lines.
 */

public tuple[real ratio, int lineCount, int duplicateLines] getDupRatio(list[loc] projFiles) 
{
	// window size
	int CHUNK_SIZE = 6;
	
	// set up some counters and keep-track-of-ers
	int dupLOCCount = 0;
	int totalLOC = 0;
	bool lastChunkWasDup = false;
	
	// this set will keep track of what blocks of code we have and haven't encountered
	set[str] encChunks = {};
	
	// variable initiator
	list[str] currLines = [];
	str currChunk = "";
	
	// loop over all of the files in the project
	for (currFile <- projFiles) 
	{
		// get the LOC from this file (no Whitespace or Comments)
		// @TODO implement funtion getLOC()
		currLines = stripEmptyLineAndComments(readFileLines(currFile));
		
		// loop over all of the chunks in this file
		for (int index <- [0..(size(currLines)-CHUNK_SIZE+1)])
		{
			// get each individual chunk as a concatenated string
			currChunk = getChunk(currLines[index..index+CHUNK_SIZE]);
			
			// check whether we have already encountered this chunk
			if (currChunk in encChunks)
			{
				// if the last chunk was a duplicate
				if (lastChunkWasDup)
				{
					// we don't have to count all of the lines in the chunk as a duplicate, we only mark the newly encountered line
					dupLOCCount += 1;
				}
				else 
				{
					// if the last chunk wasn't a duplicate, mark the whole chunk as duplicate lines and set the lastchunkwasdup toggle to true
					dupLOCCount += CHUNK_SIZE;
					lastChunkWasDup = true;
				}
			}
			else
			{
				// we have encountered an unknown chunk, include the new chunk in the encountered set and mark the last encountered chunk to not be a duplicate
				encChunks += currChunk;
				lastChunkWasDup = false;
			}
		}
		// we have parsed a complete file, reset the last chunk boolean and add the lines in this file to the total Lines Of Code counter
		lastChunkWasDup = false;
		totalLOC += size(currLines);
	}
	// testing purposes: output the found lines of code and other stats
	println("Total Lines of Code: <totalLOC>, number of duplicate lines: <dupLOCCount>");
	
	// we have parsed all of the LOC in all of the files, return the calculated result
	return <dupLOCCount * 1.0 / totalLOC,totalLOC, dupLOCCount >;
}

public str getChunk(list[str] l) {
	r = "";
	for (s <- l) { r += s; }
	return r;
}


public list[loc] getProjFiles(loc project) {
	return [f | /file(f) := getProject(project), f.extension == "java"];
}