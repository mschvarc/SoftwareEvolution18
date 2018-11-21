module Analysability

import VolumeCount;
import DuplicateCount;
import UnitSize;


import SigRating;

/**
* Calculates analysability score based on input parameters
* @param volume
* @param duplication
* @param unit 
* @return resulting analysability index
*/
public SIG_INDEX calculateAnalysability(SIG_INDEX volume, SIG_INDEX duplication, SIG_INDEX unit){

	volumeIndex = sigIndexToInt(volume);
	duplicateIndex = sigIndexToInt(duplication);
	unitIndex = sigIndexToInt(unit);
	
	int resultingIndex = (volumeIndex + duplicateIndex + unitIndex) / 3;
	return intToSigIndex(resultingIndex);
}