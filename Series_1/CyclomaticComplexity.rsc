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
import SigRating;


alias CCresult =  tuple[int lowRiskLoc, int moderateRiskLoc, int highRiskLoc, int veryHighRiskLoc, int totalLoc];
alias CCfullResult = tuple[SIG_INDEX rating, CCresult bins];

/**
* Classifies project method complexities according to the SIG methodology
* @param projectLoc project location
* @return SIG rating
*/
public CCfullResult calculateSIGCyclomaticComplexityMetricsProject(loc projectLoc){
	set[Declaration] ast = createAstsFromEclipseProject(projectLoc, true);
	result = calculateComplexityMetric(ast);
	return <calculateSIGCyclomaticComplexityMetrics(result), result>;	
}

/**
* Classifies relative method complexities according to the SIG methodology
* @return SIG rating
*/
public SIG_INDEX calculateSIGCyclomaticComplexityMetrics(CCresult result){
	real zeroThreshold = 0.0001;
	
	real moderatePercent = result.moderateRiskLoc * 1.0 / result.totalLoc;
	real highPercent = result.highRiskLoc * 1.0 / result.totalLoc;
	real veryHighPercent = result.veryHighRiskLoc * 1.0 / result.totalLoc;
	
	if(moderatePercent <= 0.25 && highPercent < zeroThreshold && veryHighPercent < zeroThreshold){
		return PLUS_PLUS();
	} else if(moderatePercent <= 0.30 && highPercent <= 0.05 && veryHighPercent < zeroThreshold){
		return PLUS();
	} else if(moderatePercent <= 0.40 && highPercent <= 0.10 && veryHighPercent < zeroThreshold){
		return ZERO();
	} else if(moderatePercent <= 50 && highPercent <= 0.15 && veryHighPercent <= 0.05){
		return MINUS();
	} else {
		return MINUS_MINUS();
	}
}

/**
* Calculates complexity metrics for given ASTs according to the SIG methodology
*/
public CCresult calculateComplexityMetric(set[Declaration] ast){
	list[tuple[int complexity, int linesOfCode]] results = [];
	for(Declaration d <- ast) {		
		results += traverseDeclaration(d);
	}
	
	int lowRiskLoc = 0;
	int moderateRiskLoc = 0;
	int highRiskLoc = 0;
	int veryHighRiskLoc = 0;
	int totalLoc = 0;
	
	for(unit <- results) {
		int cyclomaticComplexity = unit.complexity;
		
		if(cyclomaticComplexity < 11){
			lowRiskLoc += unit.linesOfCode;
		} else if(cyclomaticComplexity >= 11 && cyclomaticComplexity <= 20) {
			moderateRiskLoc += unit.linesOfCode;
		} else if(cyclomaticComplexity >= 21 && cyclomaticComplexity <= 50) {
			highRiskLoc += unit.linesOfCode;
		} else if(cyclomaticComplexity > 50) {
			veryHighRiskLoc += unit.linesOfCode;
		}
		totalLoc += unit.linesOfCode;
	}
		
	return <lowRiskLoc, moderateRiskLoc,highRiskLoc,veryHighRiskLoc,totalLoc>;
}

/**
* Calculates complexity of given declaration
* @param ast AST for which to calculate complexity
* @return list of method complexities
*/
public list[tuple[int complexity, int linesOfCode]] traverseDeclaration(Declaration ast){

	list[tuple[int complexity, int linesOfCode]] results = [];
	
	visit (ast) {
		case methodSrc:\method(_, name, _, _, Statement impl): {
				results += traverseMethodImpl(methodSrc.src, impl);
			}
		case methodSrc:\constructor(name, _,_, Statement impl): {
				results += traverseMethodImpl(methodSrc.src, impl);
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
	
	
	int branches = 1; //every program has at least 1 main branch / flow

	visit(methodImpl) {
		case \do(Statement body, Expression condition):{
				branches += 1;
			}
		case \foreach(Declaration parameter, Expression collection, Statement body):{
				branches += 1;
			}
		case \for(list[Expression] initializers, Expression condition, list[Expression] updaters, Statement body):{
				branches += 1;
				}
    	case \for(list[Expression] initializers, list[Expression] updaters, Statement body):{
    			branches += 1;
    		}
    	case \if(Expression condition, Statement thenBranch):{
    			branches += 1;
    		}
    	case \if(Expression condition, Statement thenBranch, Statement elseBranch):{
    			branches += 1;
    		}
    	case \case(Expression expression):{
    			branches += 1;
    		}
    	case \defaultCase():{
    			branches += 1;
    		}
    	case \while(Expression condition, Statement body):{
    			branches += 1;
    		}
    	case \infix(_, "&&", _): {
    		branches += 1;
    	}
    	case \infix(_, "||", _): {
    		branches += 1;
    	}
    	case \conditional(_,_,_): {
    		branches += 1;
    	}
    	default: {
    		branches += 0; //NO-OP required for block
    	}
    	/*
		The following is NOT branch itself
		\switch(Expression expression, list[Statement] statements) 
		*/
	}
	
	int ccResult = branches;
	
	int linesOfCode = size(stripEmptyLineAndComments(readFileLines(source)));
	
	return <ccResult, linesOfCode>;
}
