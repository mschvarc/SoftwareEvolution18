module Analysability

import VolumeCount;
import DuplicateCount;
import UnitSize;


import SigRating;

/**
* Calculates analysability score based on input parameters
* @param volume
* @param duplication
* @param unitSize
* @param unitTesting
* @return resulting analysability index
*/
public SIG_INDEX calculateAnalysability(SIG_INDEX volume, SIG_INDEX duplication, SIG_INDEX unitSize, SIG_INDEX unitTesting){
	volumeIndex = sigIndexToInt(volume);
	duplicateIndex = sigIndexToInt(duplication);
	unitSizeIndex = sigIndexToInt(unit);
	unitTestingIndex = sigIndex(unit);
	
	int resultingIndex = (volumeIndex + duplicateIndex + unitSizeIndex + unitTestingIndex) / 4;
	return intToSigIndex(resultingIndex);
}