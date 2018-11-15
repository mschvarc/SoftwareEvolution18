module ProjectRunner

import Analysability;
import Changeability;
import CyclomaticComplexity;
import DuplicateCount;
import Maintainability;
import SigRating;
import Testability;
import UnitSize;
import VolumeCount;
import IO;
import NewDuplicateCount;

public void runAll(){
	loc location = |project://smallsql0.21_src|;
	cc = calculateSIGCyclomaticComplexityMetricsProject(location);
	println("Cyclomatic complexity: rating: <cc.rating>, bins: <cc.bins>");
	
	dc = getSigDuplication(location);
	println("Duplication: rating: <dc.rating>, % duplicated: <dc.percentage>");
	
	us = calculateSigRatingUnitSizeAll(location);
	println("Unit size: rating: <us.rating>, avg unit size: <us.avgsize>");
	
	vc = calculateSIGRatingForProjectVolumeCount(location);
	println("Volume count: rating: <vc.rating>, total volume: <vc.volume>");
	
	
}