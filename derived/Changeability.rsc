module Changeability

import CyclomaticComplexity;
import DuplicateCount;

import SigRating;

public SIG_INDEX calculateChangeability(loc project){

	cyclomaticIndex = sigIndexToInt(calculateSIGCyclomaticComplexityMetricsProject(project));
	duplicateIndex = sigIndexToInt(calculateDuplicationSigRatingProject(project));
	
	int resultingIndex = (cyclomaticIndex + duplicateIndex) / 2;
	return intToSigIndex(resultingIndex);
}