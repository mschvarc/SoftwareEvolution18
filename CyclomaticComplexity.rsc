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
	M3 m3Model = createM3FromEclipseProject(location);
	set[Declaration] ast = createAstsFromEclipseProject(location, true);
	
	calculateComplexityMetric(ast);
	
	return;
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
		//case \switch(Expression expression, list[Statement] statements) 
		//TODO: what about switch itself, does that branch or only consider cases + default case?
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
