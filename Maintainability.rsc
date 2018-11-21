module Maintainability

import Analysability;
import Changeability;
import Testability;
import SigRating;

/**
* Calculates maintainability score based on input parameters
* @param analysability
* @param changeability
* @param testability
* @return resulting maintainability index
*/
public SIG_INDEX calculateMaintainability(SIG_INDEX analysability, SIG_INDEX changeability, SIG_INDEX testability ){
	analysabilityIndex = sigIndexToInt(analysability);
	changeabilityIndex = sigIndexToInt(changeability);
	testabilityIndex = sigIndexToInt(testability);
	
	int resultingIndex = (analysabilityIndex + changeabilityIndex + testabilityIndex) / 3;
	return intToSigIndex(resultingIndex);
}