module Testability

import CyclomaticComplexity;
import UnitSize;

public SIG_INDEX calculateTestability(loc project){

	cyclomaticIndex = sigIndexToInt(calculateAnalysability(project));
	unitIndex = -100;
	//TODO: add unit size once done
	
	int resultingIndex = (cyclomaticIndex + unitIndex) / 2;
	return intToSigIndex(resultingIndex);
}