module Testability

import CyclomaticComplexity;
import UnitSize;
import SigRating;

public SIG_INDEX calculateTestability(loc project){

	cyclomaticIndex = sigIndexToInt(calculateSIGCyclomaticComplexityMetricsProject(project));
	unitIndex = sigIndexToInt(calculateUnitSizeSIGRatingForProject(project));
	
	int resultingIndex = (cyclomaticIndex + unitIndex) / 2;
	return intToSigIndex(resultingIndex);
}