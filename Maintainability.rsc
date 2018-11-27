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
* @param stability
* @return resulting maintainability index
*/
public SIG_INDEX calculateMaintainability(SIG_INDEX analysability, SIG_INDEX changeability, SIG_INDEX testability, SIG_INDEX stability ){
	analysabilityIndex = sigIndexToInt(analysability);
	changeabilityIndex = sigIndexToInt(changeability);
	testabilityIndex = sigIndexToInt(testability);
	stabilityIndex = sigIndexToInt(stability);
	
	int resultingIndex = (analysabilityIndex + changeabilityIndex + testabilityIndex + stabilityIndex) / 4;
	return intToSigIndex(resultingIndex);
}