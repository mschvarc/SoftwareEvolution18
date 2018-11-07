module VolumeCount

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


public void runOnProject(){
	loc location = |project://smallsql0.21_src|;
	M3 m3Model = createM3FromEclipseProject(location);
	set[Declaration] ast = createAstsFromEclipseProject(location, true);
	list[loc] projectFiles = getIndividualJavaFiles(location);
	set[loc] projectMethods = methods(m3Model);
	
	int LOC = 0;
	for(srcFile <- projectFiles){
		LOC += getLinesOfCode(srcFile);
	}
	
	println(LOC);
	
	/*
    | \method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions, Statement impl)
    | \method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions)
    | \constructor(str name, list[Declaration] parameters, list[Expression] exceptions, Statement impl)
	*/
	
	//http://tutor.rascal-mpl.org/Rascal/Libraries/lang/java/m3/AST/Declaration/Declaration.html 
	println("--------");
	
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


//TODO: refactor + obfuscate
public list[loc] getIndividualJavaFiles(loc project) {
	return [f | /file(f) := getProject(project), f.extension == "java"];
}


public void processMethodAST(loc methodLoc){
	//methodAST = createAstFromEclipseFile(methodLoc, false);
	methodAST = createAstsFromEclipseProject(methodLoc, false);
	
}

public void visitMethod(Statement  methodRoot){
	
}


public int getLinesOfCode(loc file) {
	list[str] lines = readFileLines(file);
	return getLinesOfCode(lines);
}

public void processMethods(M3 model){
	myMethods = methods(model);
}

//|java+method:///smallsql/database/SSDatabaseMetaData/storesLowerCaseIdentifiers()|
//getMethodLinesOfCode(|java+method:///smallsql/database/SSDatabaseMetaData/getURL()|);

public int getMethodLinesOfCode(loc method){
	list[str] lines = readFileLines(method);
	return getLinesOfCode(lines);
}


/**
Calculates the Lines of Code (LOC) as follows:
LOC = number of lines in a location which are *not* fully whitespace.
TODO: make spec compliant by removing comments
*/
public int getLinesOfCode(list[str] lines){
	int totalLOC = 0;
	for(str line <- lines){
		//ignore completely blank lines
		if(trim(line) == ""){
			continue;
		}
		totalLOC += 1;
	};
	return totalLOC;
}
