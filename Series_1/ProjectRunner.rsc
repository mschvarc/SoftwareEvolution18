module ProjectRunner

import Analysability;
import Changeability;
import CyclomaticComplexity;
import Maintainability;
import SigRating;
import Testability;
import UnitSize;
import VolumeCount;
import IO;
import NewDuplicateCount;
import SigRating;
import Maintainability;
import AssertDensity;

public void runSmallSql(){
	runAll(|project://smallsql0.21_src|);
}

public void runHsql(){
	runAll(|project://hsqldb-2.3.1|);
}

public void runAll(loc location){
	
	printNewLine();
	cyclomatic = calculateSIGCyclomaticComplexityMetricsProject(location);
	println("Cyclomatic complexity:\nrating: <formatRating(cyclomatic.rating)>");
	printBinnedRisk("low", cyclomatic.bins.lowRiskLoc, cyclomatic.bins.totalLoc);
	printBinnedRisk("medium", cyclomatic.bins.moderateRiskLoc, cyclomatic.bins.totalLoc);
	printBinnedRisk("high", cyclomatic.bins.highRiskLoc, cyclomatic.bins.totalLoc);
	printBinnedRisk("very high", cyclomatic.bins.veryHighRiskLoc, cyclomatic.bins.totalLoc);
	
	printNewLine();
	duplication = getSigDuplication(location);
	println("Duplication: rating: <formatRating(duplication.rating)>, lines duplicated: <duplication.result.ratio * 100>%");
	println("Duplicated lines: <duplication.result.duplicateLines> out of: <duplication.result.lineCount>");
	
	printNewLine();
	unitSize = calculateSigRatingUnitSizeAll(location);
	println("Unit size: rating: <formatRating(unitSize.rating)>");
	printBinnedRisk("low", unitSize.bins.low, unitSize.bins.total);
	printBinnedRisk("medium", unitSize.bins.moderate, unitSize.bins.total);
	printBinnedRisk("high", unitSize.bins.high, unitSize.bins.total);
	printBinnedRisk("very high", unitSize.bins.veryHigh, unitSize.bins.total);
	
	printNewLine();
	unitTesting = calcAssertDensitySIGRating(location);
	println("Unit Testing: rating: <formatRating(unitTesting.rating)>");
	println("Methods without assert statements: <unitTesting.result.uselessTestCount>");
	println("Methods with assert statements: <unitTesting.result.usefulTestCount>");
	println("Average assert density: <unitTesting.result.usefulAssertDensity>");
	
	printNewLine();
	volume = calculateSIGRatingForProjectVolumeCount(location);
	println("Volume count: rating: <formatRating(volume.rating)>, total volume: <volume.volume>");
	
	printNewLine();
	analysability = calculateAnalysability(volume.rating, duplication.rating, unitSize.rating, unitTesting.rating);
	println("Analysability: <formatRating(analysability)>");
	
	printNewLine();
	changeability = calculateChangeability(cyclomatic.rating, duplication.rating);
	println("Changeability: <formatRating(changeability)>");
	
	printNewLine();
	stability = unitTesting.rating;
	println("Stability: <formatRating(stability)>");
	
	printNewLine();
	testability = calculateTestability(cyclomatic.rating, unitSize.rating, unitTesting.rating);
	println("Testability: <formatRating(testability)>");
	
	
	printNewLine();
	maintainability = calculateMaintainability(analysability, changeability, testability, stability);
	println("Maintainability: <formatRating(maintainability)>");
	
		
}

private void printBinnedRisk(str riskType, int relative, int total){
	real percentage = relative * 1.0 / total * 100;
	println("<riskType> risk: <relative> | <percentage>%");
}

private void printNewLine(){
	println("------------------");
}
