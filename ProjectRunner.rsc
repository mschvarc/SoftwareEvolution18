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

public void runSmallSql(){
	runAll(|project://smallsql0.21_src|);
}

public void runHsql(){
	runAll(|project://hsqldb-2.3.1|);
}

public void runAll(loc location){
	
	printNewLine();
	cyclomatic = calculateSIGCyclomaticComplexityMetricsProject(location);
	println("Cyclomatic complexity:\nrating: <cyclomatic.rating>");
	printBinnedRisk("low", cyclomatic.bins.lowRiskLoc, cyclomatic.bins.totalLoc);
	printBinnedRisk("medium", cyclomatic.bins.moderateRiskLoc, cyclomatic.bins.totalLoc);
	printBinnedRisk("high", cyclomatic.bins.highRiskLoc, cyclomatic.bins.totalLoc);
	printBinnedRisk("very high", cyclomatic.bins.veryHighRiskLoc, cyclomatic.bins.totalLoc);
	
	printNewLine();
	duplication = getSigDuplication(location);
	println("Duplication: rating: <duplication.rating>, lines duplicated: <duplication.result.ratio * 100>%");
	println("Duplicated lines: <duplication.result.duplicateLines> out of: <duplication.result.lineCount>");
	
	printNewLine();
	unit = calculateSigRatingUnitSizeAll(location);
	println("Unit size: rating: <unit.rating>");
	printBinnedRisk("low", unit.bins.low, unit.bins.total);
	printBinnedRisk("medium", unit.bins.moderate, unit.bins.total);
	printBinnedRisk("high", unit.bins.high, unit.bins.total);
	printBinnedRisk("very high", unit.bins.veryHigh, unit.bins.total);
	
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

private void printBinnedRisk(str riskType, int relative, int total){
	real percentage = relative * 1.0 / total * 100;
	println("<riskType> risk: <relative> | <percentage>%");
}

private void printNewLine(){
	println("------------------");
}
