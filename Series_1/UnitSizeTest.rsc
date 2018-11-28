module UnitSizeTest

import UnitSize;
import IO;

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

public test bool testUnitSizeSingleMethod() {
	loc thisProj = |project://series1/|;
	
	M3 thisModel = createM3FromEclipseProject(thisProj);
	
	set[loc] theseMethods = methods(thisModel);
	
	num expSize = 14;
	num unitSize;
	
	for (thisMethod <- theseMethods) {
		unitSize = calculateUnitSize(thisMethod);
		
		print("Testing Method: ");
		println(thisMethod);
		print("Expected size: ");
		print(expSize);
		print(", Actual Size: ");
		print(unitSize);
		print(", Match = ");
		println(expSize == unitSize ? "TRUE" : "FALSE");
		if(expSize != unitSize){return false;}
	}
	
	return true; //all assertions passed
}

public test bool testUnitSizeSingleProject() {
	loc thisProj = |project://series1/|;
	
	M3 thisModel = createM3FromEclipseProject(thisProj);
		
	num expSize = 2;
	int projAvgSize = calculateAverageUnitSizePerProject(
							calculateUnitSizeForProject(thisModel)).total;
		
	print("Testing Project: ");
	println(thisProj);
	print("Expected size: ");
	print(expSize);
	print(", Actual Size: ");
	print(projAvgSize);
	print(", Match = ");
	println(expSize == projAvgSize ? "TRUE" : "FALSE");
	
	return expSize == projAvgSize;
		
}