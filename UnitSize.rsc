module UnitSize

import IO;

import List;
import String;
import Map;
 
import CommentStripper;

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import analysis::m3::AST;

import SigRating;

/**
* Calculates unit size for a project according to the SIG methodology.
* @param location
* @return rating and average unit size
*/
public tuple[SIG_INDEX rating, real avgsize] calculateSigRatingUnitSizeAll(loc location){
	result = calculateAverageUnitSizePerProject(
				calculateUnitSizeForProject(
					createM3FromEclipseProject(location)));
	return <calculateSIGRatingForUnitSize(result), result>;
}

/**
* Calculates unit size for a project according to the SIG methodology.
* @param location
* @return SIG rating
*/
public SIG_INDEX calculateUnitSizeSIGRatingForProject(loc location){
	return calculateSIGRatingForUnitSize(
		calculateAverageUnitSizePerProject(
			calculateUnitSizeForProject(
				createM3FromEclipseProject(location))));
}


/**
* Classifies average LOC per unit to a SIG rating
*/
public SIG_INDEX calculateSIGRatingForUnitSize(real avgLOC){
//TODO: literature study for ratings
	if(avgLOC < 15){
		return PLUS_PLUS();
	} else if(avgLOC >= 15 && avgLOC < 20) {
		return PLUS();
	} else if(avgLOC >= 20 && avgLOC < 25) {
		return ZERO();
	} else if(avgLOC >= 25 && avgLOC < 30) {
		return MINUS();
	} else  {
		return MINUS_MINUS();
	}
}

/**
* Calculates average unit size for the project
*/
public real calculateAverageUnitSizePerProject(map[loc, int] unitSizes){
	int totalLOC = 0;
	int methodCount = size(unitSizes);
	
	for(<k,v> <- toRel(unitSizes)) {
		totalLOC += v;
	}
		
	return totalLOC * 1.0 / methodCount;
}

/**
* Calculates unit size for a given M3 model
*/
public map[loc, int] calculateUnitSizeForProject(M3 model) {
	set[loc] myMethods = methods(model);
	map[loc, int] resultMethodLoc = ();

	for(meth <- myMethods) { 
		resultMethodLoc[meth] = calculateUnitSize(meth);	
	}
	return resultMethodLoc;
}

/**
* Calculates unit size for one file or method
*/
public int calculateUnitSize(loc methodLoc){
	list[str] rawLines = readFileLines(methodLoc);
	int lineCount = size(stripEmptyLineAndComments(rawLines));	
	return lineCount;
}
