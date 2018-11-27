module AssertDensity

import CommentStripper;
import IO;
import List;
import Map;
import Relation;
import Set;
import String;
import analysis::m3::AST;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::m3::Core;
import util::Math;
import util::Resources;
import Map;
import SigRating;

alias AssertDensityReport = tuple[int uselessTestCount, 
									int usefulTestCount, 
									real usefulAssertDensity];
									


public tuple[SIG_INDEX rating, AssertDensityReport result]  calcAssertDensitySIGRating(loc proj) {
	AssertDensityReport result = getAssertDensityForProject(proj);
	real uselessRatio = result.uselessTestCount * 1.0 / (result.uselessTestCount + result.usefulTestCount);
	
	if (uselessRatio > 0.1) { return <MINUS_MINUS(),result>; }
	else if (uselessRatio > 0.05) {return <MINUS(),result>; }
	else if (result.usefulAssertDensity < 3) { return <ZERO(),result>; }
	else if (result.usefulAssertDensity < 7) { return <PLUS(),result>; }
	return <PLUS_PLUS(),result>;
}

public AssertDensityReport getAssertDensityForProject(loc proj) {
	// create model from the project
	M3 model = createM3FromEclipseProject(proj);
	
	// init result variable
	AssertDensityReport result = <0,0,0.0>;
	
	// get all of the methods
	set[loc] projMethods = methods(model);
	
	// counter
	int totalAsserts = 0;
										
	// for each method in the project:
	for (thisMethod <- projMethods) {
		// get the function name of this method
		str thisMethodName = getMethodName(thisMethod);	
		
		if( contains(thisMethodName, "test") || contains(thisMethodName, "Test")) {	
			// get the amount of asserts for this method
			int numberOfAsserts = getNumberOfAssertsForMethod(thisMethod);
			
			if (numberOfAsserts >= 1) {
				// add it to the total number of test methods found
				result.usefulTestCount += 1;
				
				totalAsserts += numberOfAsserts;
			} else {
				result.uselessTestCount += 1;
			}
		}
	}
	result.usefulAssertDensity = totalAsserts * 1.0 / (result.usefulTestCount);
	
	return result;
}

public str getMethodName(loc meth) {
	// parse the location path
	str methPath = meth.path;
	
	// split the string on the slashes
	list[str] parts = split("/", methPath);
	
	// split the last part of the original by parentheses to get the function name
	list[str] lastParts = split("(", parts[-1]);
	
	// return the first chunk, this is the function name
	return lastParts[0];
}

public int getNumberOfAssertsForMethod(loc meth) {
	// convert method location into list of method lines, strip whitelines and comments
	list[str] methLines = stripEmptyLineAndComments(readFileLines(meth));
	
	// init total
	int totalAsserts = 0;
			
	// count the number of assert calls in the method
	for (line <- methLines) {
		if(contains(line, "assert")) { totalAsserts += 1; } //assert*
		if(/.*expect.*/ := line) {totalAsserts += 1;} //Assert4J expect exception
		if(/@Test\(.*expected=.*\.class.*\)/ := line) {totalAsserts += 1;} //JUnit @Test with exception
	}
	
	// return the assert number
	return totalAsserts;
}