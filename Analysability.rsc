module Analysability

import VolumeCount;
import DuplicateCount;
import UnitSize;


import SigRating;

public SIG_INDEX calculateAnalysability(SIG_INDEX volume, SIG_INDEX duplication, SIG_INDEX unit){

	volumeIndex = sigIndexToInt(volume);
	duplicateIndex = sigIndexToInt(duplication);
	unitIndex = sigIndexToInt(unit);
	
	int resultingIndex = (volumeIndex + duplicateIndex + unitIndex) / 3;
	return intToSigIndex(resultingIndex);
}