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
public SIG_INDEX calculateTestability(SIG_INDEX cyclomatic, SIG_INDEX unitSize, SIG_INDEX unitTesting){

	cyclomaticIndex = sigIndexToInt(cyclomatic);
	unitSizeIndex = sigIndexToInt(unitSize);
	unitTestingIndex = sigIndexToInt(unitTesting);
	
	int resultingIndex = (cyclomaticIndex + unitIndex + unitTestingIndex) / 3;
	return intToSigIndex(resultingIndex);
}