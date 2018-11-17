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
import SigRating;
import Maintainability;

public void runAll(){
	loc location = |project://smallsql0.21_src|;
	
	printNewLine();
	cyclomatic = calculateSIGCyclomaticComplexityMetricsProject(location);
	println("Cyclomatic complexity:\nrating: <cyclomatic.rating>");
	printCyclomaticRisk("low", cyclomatic.bins.lowRiskLoc, cyclomatic.bins.totalLoc);
	printCyclomaticRisk("medium", cyclomatic.bins.moderateRiskLoc, cyclomatic.bins.totalLoc);
	printCyclomaticRisk("high", cyclomatic.bins.highRiskLoc, cyclomatic.bins.totalLoc);
	printCyclomaticRisk("very high", cyclomatic.bins.veryHighRiskLoc, cyclomatic.bins.totalLoc);
	
	printNewLine();
	duplication = getSigDuplication(location);
	println("Duplication: rating: <duplication.rating>, lines duplicated: <duplication.percentage * 100>%");
	
	printNewLine();
	unit = calculateSigRatingUnitSizeAll(location);
	println("Unit size: rating: <unit.rating>, avg unit size: <unit.avgsize>");
	
	printNewLine();
	volume = calculateSIGRatingForProjectVolumeCount(location);
	println("Volume count: rating: <volume.rating>, total volume: <volume.volume>");
	
	printNewLine();
	analysability = calculateAnalysability(volume.rating, duplication.rating, unit.rating);
	println("Analysability: <analysability>");
	
	printNewLine();
	changeability = calculateChangeability(cyclomatic.rating, duplication.rating);
	println("Changeability: <changeability>");
	
	printNewLine();
	testability = calculateTestability(cyclomatic.rating, unit.rating);
	println("Testability: <testability>");
	
	printNewLine();
	maintainability = calculateMaintainability(analysability, changeability, testability);
	println("Maintainability: <maintainability>");
		
}

private void printCyclomaticRisk(str riskType, int relative, int total){
	real percentage = relative * 1.0 / total * 100;
	println("<riskType> risk: <relative> | <percentage>%");
}

private void printNewLine(){
	println("------------------");
}
