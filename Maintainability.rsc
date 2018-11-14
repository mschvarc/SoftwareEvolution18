module Maintainability

import Analysability;
import Changeability;
import Testability;


public SIG_INDEX calculateMaintainability(loc project){

	analysabilityIndex = sigIndexToInt(calculateAnalysability(project));
	changeabilityIndex = sigIndexToInt(calculateChangeability(project));
	testabilityIndex = sigIndexToInt(calculateTestability(project));
	
	int resultingIndex = (analysabilityIndex + changeabilityIndex + testabilityIndex) / 3;
	return intToSigIndex(resultingIndex);
}