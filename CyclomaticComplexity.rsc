module CyclomaticComplexity

import IO;
import List;
import String;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import analysis::m3::AST;
import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import List;
import Set;
import Relation;
import Map;
import String;
import util::Math;
import util::Resources;
import List;
import String;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import analysis::m3::AST;

import CommentStripper;


public void CCrunOnProject(){
	loc location = |project://smallsql0.21_src|;
	
	printSIGCyclomaticComplexityMetrics(location);
	
	return;
}

data  SIG_INDEX = PLUS_PLUS() | PLUS() | ZERO() | MINUS() | MINUS_MINUS();

public SIG_INDEX printSIGCyclomaticComplexityMetrics(loc projectLoc){
	set[Declaration] ast = createAstsFromEclipseProject(projectLoc, true);	
	result = calculateComplexityMetric(ast);
	
	real zeroThreshold = 0.0001;
	
	real moderatePercent = result.moderateRiskLoc * 1.0 / result.totalLoc;
	real highPercent = result.highRiskLoc * 1.0 / result.totalLoc;
	real veryHighPercent = result.veryHighRiskLoc * 1.0 / result.totalLoc;
	
	if(moderatePercent <= 0.25 && highPercent < zeroThreshold && veryHighPercent < zeroThreshold){
		println("++");
		return PLUS_PLUS();
	} else if(moderatePercent <= 0.30 && highPercent <= 0.05 && veryHighPercent < zeroThreshold){
		println("+");
		return PLUS();
	} else if(moderatePercent <= 0.40 && highPercent <= 0.10 && veryHighPercent < zeroThreshold){
		println("O");
		return ZERO();
	} else if(moderatePercent <= 50 && highPercent <= 0.15 && veryHighPercent < 0.05){
		println("-");
		return MINUS();
	} else {
		println("--");
		return MINUS_MINUS();
	}
	
}


public tuple[int moderateRiskLoc, int highRiskLoc, int veryHighRiskLoc, int totalLoc] calculateComplexityMetric(set[Declaration] ast){
	list[tuple[int complexity, int linesOfCode]] results = [];
	for(Declaration d <- ast) {		
		results += traverseDeclaration(d);
	}
	
	int moderateRiskLoc = 0;
	int highRiskLoc = 0;
	int veryHighRiskLoc = 0;
	int totalLoc = 0;
	
	for(unit <- results) {
		int cyclomaticComplexity = unit.complexity;
		
		if(cyclomaticComplexity >= 11 && cyclomaticComplexity <= 20) {
			moderateRiskLoc += unit.linesOfCode;
		} else if(cyclomaticComplexity >= 21 && cyclomaticComplexity <= 50) {
			highRiskLoc += unit.linesOfCode;
		} else if(cyclomaticComplexity > 50) {
			veryHighRiskLoc += unit.linesOfCode;
		}
		totalLoc += unit.linesOfCode;
	}
	
	println("moderate: <moderateRiskLoc>, high: <highRiskLoc>, vhigh: <veryHighRiskLoc>, total: <totalLoc>");
	
	return <moderateRiskLoc,highRiskLoc,veryHighRiskLoc,totalLoc>;
}

//returns list of method complexities
public list[tuple[int complexity, int linesOfCode]] traverseDeclaration(Declaration ast){

	list[tuple[int complexity, int linesOfCode]] results = [];
	
	visit (ast) {
		case methodSrc:\method(_, name, _, _, Statement impl): {
				println(name);
				results += traverseMethodImpl(methodSrc.src, impl);
				println("--------");
			}
		case methodSrc:\constructor(name, _,_, Statement impl): {
				println(name);
				results += traverseMethodImpl(methodSrc.src, impl);
				println("--------");
				//impl.src gives source location range, without the method declaration line
			}
		}
	return results;
}

//returns complexity as a number
public tuple[int complexity, int linesOfCode] traverseMethodImpl(loc source, Statement methodImpl) {

	//https://www.guru99.com/cyclomatic-complexity.html
	//https://www.softwaretestingclass.com/cyclomatic-complexity-with-example/
	//http://tutor.rascal-mpl.org/Recipes/Common/ColoredTrees/ColoredTrees.html
	//!!! no recursive visit calls needed!
	
	int branches = 0;

	visit(methodImpl) {
		case \do(Statement body, Expression condition):{
				println("do block");
				branches += 1;
			}
		case \foreach(Declaration parameter, Expression collection, Statement body):{
				println("fe");
				branches += 1;
			}
		case \for(list[Expression] initializers, Expression condition, list[Expression] updaters, Statement body):{
				println("for");
				branches += 1;
				}
    	case \for(list[Expression] initializers, list[Expression] updaters, Statement body):{
    			println("for");
    			branches += 1;
    		}
    	case \if(Expression condition, Statement thenBranch):{
    			println("if");
    			branches += 1;
    		}
    	case \if(Expression condition, Statement thenBranch, Statement elseBranch):{
    			println("if");
    			branches += 1;
    		}
		/*
		The following is NOT branch itself
		\switch(Expression expression, list[Statement] statements) 
		*/
    	case \case(Expression expression):{
    			println("case");
    			branches += 1;
    		}
    	case \defaultCase():{
    			println("default case");
    			branches += 1;
    		}
    	case \while(Expression condition, Statement body):{
    			println("while");
    			branches += 1;
    		}
    	default: {
    		branches += 0; //NO-OP required for block
    	}
	}
	
	int ccResult = branches;
	println("CC: <ccResult>");
	
	int linesOfCode = size(stripEmptyLineAndComments(readFileLines(source)));
	
	return <ccResult, linesOfCode>;
}
