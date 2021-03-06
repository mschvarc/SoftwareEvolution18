module VolumeCount

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

import CommentStripper;
import SigRating;


/**
* Classifies volume for Java project according to SIG methodology
* @param location project location
* @return rating and total volume (LOC)
*/
public tuple[SIG_INDEX rating, int volume] calculateSIGRatingForProjectVolumeCount(loc location){
	result = calculateVolumeCountForProject(location);
	return <calculateSIGRatingForVolumeCount(result), result>;
}

/**
* Classifies volume for Java LOC according to SIG methodology
* @param LOC
* @return rating
*/
public SIG_INDEX calculateSIGRatingForVolumeCount(int LOC){
	int K = 1000;
	if(LOC < 66*K){
		return PLUS_PLUS();
	} else if(LOC >= 66*K && LOC < 246*K) {
		return PLUS();
	} else if(LOC >= 246*K && LOC < 665*K) {
		return ZERO();
	} else if(LOC >= 665*K && LOC < 1310*K) {
		return MINUS();
	} else  {
		return MINUS_MINUS();
	}
}

public int calculateVolumeCountForProject(loc location){
	list[loc] projectFiles = getIndividualJavaFiles(location);
	
	int LOC = 0;
	for(srcFile <- projectFiles){
		LOC += getLinesOfCode(srcFile);
	}
	return LOC;
}

private list[loc] getIndividualJavaFiles(loc project) {
	return [f | /file(f) := getProject(project), f.extension == "java"];
}


private int getLinesOfCode(loc location) {
	list[str] rawLines = readFileLines(location);
	list[str] lines = stripEmptyLineAndComments(rawLines);
	return size(lines);
}
