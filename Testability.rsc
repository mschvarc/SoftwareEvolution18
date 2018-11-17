module Testability

import CyclomaticComplexity;
import UnitSize;
import SigRating;

/**
* Calculates testability score based on input parameters
* @param cyclomatic
* @param unit 
* @return testability analysability index
*/
public SIG_INDEX calculateTestability(SIG_INDEX cyclomatic, SIG_INDEX unit){

	cyclomaticIndex = sigIndexToInt(cyclomatic);
	unitIndex = sigIndexToInt(unit);
	
	int resultingIndex = (cyclomaticIndex + unitIndex) / 2;
	return intToSigIndex(resultingIndex);
}