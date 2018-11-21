module Changeability

import CyclomaticComplexity;
import DuplicateCount;

import SigRating;

/**
* Calculates changability score based on input parameters
* @param cyclomatic
* @param duplication
* @return resulting changability index
*/
public SIG_INDEX calculateChangeability(SIG_INDEX cyclomatic, SIG_INDEX duplication){

	cyclomaticIndex = sigIndexToInt(cyclomatic);
	duplicateIndex = sigIndexToInt(duplication);
	
	int resultingIndex = (cyclomaticIndex + duplicateIndex) / 2;
	return intToSigIndex(resultingIndex);
}