module Analysability

import VolumeCount;
import DuplicateCount;
import UnitSize;


import SigRating;

public SIG_INDEX calculateAnalysability(loc project){

	volumeIndex = sigIndexToInt(calculateSIGRatingForProjectVolumeCount(project));
	duplicateIndex = sigIndexToInt(calculateDuplicationSigRatingProject(project));
	unitIndex = -100;
	//TODO: add unitsize once done
	
	int resultingIndex = (volumeIndex + duplicateIndex + unitIndex) / 3;
	return intToSigIndex(resultingIndex);
}