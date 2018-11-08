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


public void CCrunOnProject(){
	loc location = |project://smallsql0.21_src|;
	M3 m3Model = createM3FromEclipseProject(location);
	set[Declaration] ast = createAstsFromEclipseProject(location, true);
	
	for(Declaration d <- ast) {		
		traverseDeclaration(d);
	}
	
	return;
}


public void traverseDeclaration(Declaration ast){
	list[str] res = [];

	visit (ast) {
		case methodSrc:\method(_, name, _, _, Statement impl): {
				println(name);
				//println(impl);
				traverseMethodImpl(impl);
				println("--------");
			}
		case methodSrc:\constructor(name, _,_, Statement impl): {
				println(name);
				//println(impl);
				traverseMethodImpl(impl);
				println("--------");
				//impl.src gives source location range, without the method declaration line
			}
		}
	println(res);
}

public void traverseMethodImpl(Statement methodImpl) {

	//https://www.guru99.com/cyclomatic-complexity.html
	//https://www.softwaretestingclass.com/cyclomatic-complexity-with-example/
	//http://tutor.rascal-mpl.org/Recipes/Common/ColoredTrees/ColoredTrees.html
	//!!! no recursive visit calls needed!
	int edges = 0;
	int nodes = 0;

	visit(methodImpl) {
		case \do(Statement body, Expression condition):{
				println("do block");
				edges += 2;
				nodes += 1;
			}
		case \foreach(Declaration parameter, Expression collection, Statement body):{
				println("fe");
				edges += 2;
				nodes += 1;
			}
		case \for(list[Expression] initializers, Expression condition, list[Expression] updaters, Statement body):{
				println("for");
				edges += 2;
				nodes += 1;
				}
    	case \for(list[Expression] initializers, list[Expression] updaters, Statement body):{
    			println("for");
    			edges += 2;
				nodes += 1;
    		}
    	case \if(Expression condition, Statement thenBranch):{
    			println("if");
    			edges += 2;
				nodes += 1;
    		}
    	case \if(Expression condition, Statement thenBranch, Statement elseBranch):{
    			println("if");
    			edges += 2;
				nodes += 1;
    		}
		/*
		//case \switch(Expression expression, list[Statement] statements) 
		//TODO: what about switch itself, does that branch or only consider cases + default case?
		*/
    	case \case(Expression expression):{
    			println("case");
    			edges += 2;
				nodes += 1;
    		}
    	case \defaultCase():{
    			println("default case");
    			edges += 2;
				nodes += 1;
    		}
    	case \while(Expression condition, Statement body):{
    			println("while");
    			edges += 2;
				nodes += 1;
    		}
    	default: {
    		edges += 1;
    		nodes += 1;
    	}
	}
	
	println("edges: <edges>, nodes: <nodes>");

}


public void cyclomaticComplexityMethod(loc method){
	
}


public void processMethodAST(loc methodLoc){
	//methodAST = createAstFromEclipseFile(methodLoc, false);
	methodAST = createAstsFromEclipseProject(methodLoc, false);
	
}
