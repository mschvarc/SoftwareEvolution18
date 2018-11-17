module Maintainability

import Analysability;
import Changeability;
import Testability;
import SigRating;


public SIG_INDEX calculateMaintainability(SIG_INDEX analysability, SIG_INDEX changeability, SIG_INDEX testability ){

	analysabilityIndex = sigIndexToInt(analysability);
	changeabilityIndex = sigIndexToInt(changeability);
	testabilityIndex = sigIndexToInt(testability);
	
	int resultingIndex = (analysabilityIndex + changeabilityIndex + testabilityIndex) / 3;
	return intToSigIndex(resultingIndex);
}