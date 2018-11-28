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

alias USresult =  tuple[int low, int moderate, int high, int veryHigh, int total];
alias USfullResult = tuple[SIG_INDEX rating, USresult bins];


/**
* Calculates unit size for a project according to the SIG methodology.
* @param location
* @return UnitSize full result
*/
public USfullResult calculateSigRatingUnitSizeAll(loc location){
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
public SIG_INDEX calculateSIGRatingForUnitSize(USresult result)
{
	real moderatePercent = result.moderate * 1.0 / result.total;
	real highPercent = result.high * 1.0 / result.total;
	real veryHighPercent = result.veryHigh * 1.0 / result.total;
	
	if(moderatePercent <= 0.25 && highPercent == 0 && veryHighPercent == 0){
		return PLUS_PLUS();
	} else if(moderatePercent <= 0.30 && highPercent <= 0.05 && veryHighPercent == 0){
		return PLUS();
	} else if(moderatePercent <= 0.40 && highPercent <= 0.10 && veryHighPercent == 0){
		return ZERO();
	} else if(moderatePercent <= 50 && highPercent <= 0.15 && veryHighPercent <= 0.05){
		return MINUS();
	} else {
		return MINUS_MINUS();
	}
}

/**
* Calculates average unit size for the project
*/
public USresult calculateAverageUnitSizePerProject(map[loc, int] unitSizes){
	USresult result = <0,0,0,0,0>;
	
	for(<k,v> <- toRel(unitSizes)) {
		if (v < 20) { result.low += 1; result.total += 1; }
		else if (v < 50) { result.moderate += 1; result.total += 1; }
		else if (v < 100) { result.high += 1; result.total += 1; }
		else { result.veryHigh += 1; result.total += 1; }
	}
		
	return result;
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
