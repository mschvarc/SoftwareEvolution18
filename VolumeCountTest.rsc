module VolumeCountTest

import VolumeCount;
import IO;
import SigRating;


public test bool testVolumeSubdirectory() {
	result = calculateVolumeCountForProject(|project://test/src/tests/|);
	return result == 119;
}


public test bool testPP(){
	result = calculateSIGRatingForVolumeCount(65000);
	return result == PLUS_PLUS();
}


public test bool testP(){
	result = calculateSIGRatingForVolumeCount(200000);
	return result == PLUS();
}


public test bool testZ(){
	result = calculateSIGRatingForVolumeCount(650000);
	return result == ZERO();
}

public test bool testM(){
	result = calculateSIGRatingForVolumeCount(1000000);
	return result == MINUS();
}

public test bool testMM(){
	result = calculateSIGRatingForVolumeCount(1350000);
	return result == MINUS_MINUS();
}
