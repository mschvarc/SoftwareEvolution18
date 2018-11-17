module Changeability

import CyclomaticComplexity;
import DuplicateCount;

import SigRating;

public SIG_INDEX calculateChangeability(SIG_INDEX cyclomatic, SIG_INDEX duplication){

	cyclomaticIndex = sigIndexToInt(cyclomatic);
	duplicateIndex = sigIndexToInt(duplication);
	
	int resultingIndex = (cyclomaticIndex + duplicateIndex) / 2;
	return intToSigIndex(resultingIndex);
}