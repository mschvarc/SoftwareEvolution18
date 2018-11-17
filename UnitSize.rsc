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


public tuple[SIG_INDEX rating, real avgsize] calculateSigRatingUnitSizeAll(loc location){
	result = calculateAverageUnitSizePerProject(
				calculateUnitSizeForProject(
					createM3FromEclipseProject(location)));
	return <calculateSIGRatingForUnitSize(result), result>;
}

public SIG_INDEX calculateUnitSizeSIGRatingForProject(loc location){
	return calculateSIGRatingForUnitSize(
		calculateAverageUnitSizePerProject(
			calculateUnitSizeForProject(
				createM3FromEclipseProject(location))));
}


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

public real calculateAverageUnitSizePerProject(map[loc, int] unitSizes){
	int totalLOC = 0;
	int methodCount = size(unitSizes);
	
	for(<k,v> <- toRel(unitSizes)) {
		totalLOC += v;
	}
		
	return totalLOC * 1.0 / methodCount;
}

public map[loc, int] calculateUnitSizeForProject(M3 model) {
	set[loc] myMethods = methods(model);
	map[loc, int] resultMethodLoc = ();

	for(meth <- myMethods) { 
		resultMethodLoc[meth] = calculateUnitSize(meth);	
	}
	return resultMethodLoc;
}


public int calculateUnitSize(loc methodLoc){
	list[str] rawLines = readFileLines(methodLoc);
	int lineCount = size(stripEmptyLineAndComments(rawLines));	
	return lineCount;
}
