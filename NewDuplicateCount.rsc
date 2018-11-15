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

/**
 *  
 */

public real getDupRatio(loc proj) 
{
	// get all of the individual Java Files from the project
	list[loc] projFiles = getProjFiles(proj);
	
	// no magic numbers
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
		for (int index <- [0..(size(currLines)-6)])
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
	return dupLOCCount * 1.0 / totalLOC;
}

public str getChunk(list[str] l) {
	r = "";
	for (s <- l) { r += s; }
	return r;
}


public list[loc] getProjFiles(loc project) {
	return [f | /file(f) := getProject(project), f.extension == "java"];
}