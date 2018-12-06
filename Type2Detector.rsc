module Type2Detector


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
import Node;

/*

https://stackoverflow.com/questions/47555798/comparing-ast-nodes


*/

public void testProject(){
	parseProject(|project://smallsql0.21_src|);
	//parseProject(|project://softevo|);
}



public void parseProject(loc projectLoc){
	set[Declaration] ast = createAstsFromEclipseProject(projectLoc, true);
	traverseProject(ast);
}



public void traverseProject(set[Declaration] ast){	
	for(Declaration d <- ast) {		
		traverseDeclaration(d);
	}
}


public void traverseDeclaration(Declaration ast){

	/*visit (ast) {
		case methodSrc:\method(_, name, _, _, Statement impl): {
				traverseMethodImpl(methodSrc.src, impl);
			}
		case methodSrc:\constructor(name, _,_, Statement impl): {
				traverseMethodImpl(methodSrc.src, impl);
				//impl.src gives source location range, without the method declaration line
			}
		}*/
		
	str overrideVarName = "var";
	str charName = "x";
	str numVal = "1";
	Type overrideType = wildcard();
	str metName = "met";
		
	ast = visit(ast) {
		case \variable(_, extraDimensions) => \variable(overrideVarName, extraDimensions)
		case \variable(_, extraDimensions, init) => \variable(overrideVarName, extraDimensions, init)
		//case \characterLiteral(_) => \characterLiteral(charName)
		case \cast(_, e) => \cast(overrideType, e)
		//case \number(_) => \number(numVal)
		case \type(_) => \type(overrideType)
		case \simpleName(_) => \simpleName(charName)
		//\method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions, Statement impl)
		//case \method(_, _, parameters, exceptions, impl) => \method(overrideType, metName, parameters, exceptions, impl)
 		//case methodSrc:\method(ret, _, parameters, exceptions) => \method(ret, metName, parameters, exceptions)
	};
	
	 /*visit(ast){
		case node n:   {
			println("---------");
			println("raw: <n>");
			println("node count: <getNodeCountRec(n)>");
			println("annotations: <getAnnotations(n)>");
			println("kw: <getKeywordParameters(n)>");
		}
	}*/
	
	// ast = unset(ast);
		
	/* println(ast);
	println("---------*****-----------");
	println("---------*****-----------");
	println(getAnnotations(ast));
	println(getChildren(ast));
	println(getName(ast));
	*/
	
	makeSets(ast);
}


public map[node, set[node]] makeSets(Declaration ast){
	map[node, set[node]] results = ();
	int nodeSizeThreshold = 6;
	
	visit(ast) {
		case node n : {
			//we need to do highlighting, can't do without SRC
			if("src" in getKeywordParameters(n) ){
				//println(getName(n));
				//println(n);
				node cleared = unsetRec(n);
				if(getNodeCountRec(cleared) > nodeSizeThreshold){
					if(cleared in results) {
						results[cleared] += n;
					}
					else {
						results[cleared] = {n};
					}
				}
			}
		}
	}
	
	map[node, set[node]] nonDuplicatedResults = ();
	for(node n <- results){
		if(size(results[n]) > 1) {
			//println("<getName(n)> ; <size(results[n])> ; <getKeywordParameters(getOneFrom(results[n]))>");
			nonDuplicatedResults += (n : results[n]);
		}
	}
	
	subsume(nonDuplicatedResults);
	
	return nonDuplicatedResults;
}

public map[node, set[node]] subsume(map[node, set[node]] input) {
	
	map[node, set[node]] output = input; //TODO: deep clone
	
	//TODO: do fixed point iteration
	//generate pairs
	for(outer <- input) {
		for(inner <- input) {
			if (outer == inner) {
				continue;
			}
			
			int outerCount = getNodeCountRec(outer);
			int innerCount = getNodeCountRec(inner);
			
			//GREATER THAN: bigger set can not be subsumed by smaller set
			//EQUAL: can't be same size, different equivalence class
			//LESS THAN: only smaller set can be subsumed by bigger set
			if(outerCount >= innerCount) {
				continue;
			}
			
			//assertions: outer < inner
			
			//if inner SUBSET outer:
			//remove inner from results
			//SEE: http://tutor.rascal-mpl.org/Rascal/Patterns/Abstract/Descendant/Descendant.html
			outerPattern = getOneFrom(input[outer]);
			innerPattern = getOneFrom(input[inner]);
			
			if( / outer := inner) {
				println("found subtree, outer <outerCount>  SS inner: <innerCount>, inspecting");
				
				
				//subsume only if all outer with src match inner with src (same file subsumption for entire class)
				bool canSubsume = true;
				for(outerSrc <- input[outer]){
					bool matchFoundInner = false;
					for(innerSrc <- input[inner]){
						if(/ outerSrc :=  innerSrc){
							matchFoundInner = true;
							break;
						}
					}
					if(!matchFoundInner){
						canSubsume = false;
						break;
					}
				}
				if(canSubsume) {
					println("subsumed with SRC match");
					output = delete(output, outer);
					
					/*
					println("--------");
					println("--------");
					println(getOneFrom(input[outer]));
					println("--------");
					println("LARGER");
					println("--------");
					println(getOneFrom(input[inner]));
					println("--------");
					println("--------");
					*/
					
					
					break; //this outer pattern is deleted, go to next one
				} else {
					println("subsumption failed due to SRC mismatch");
				}
			} 
		}
	}
	
	println("input size <size(input)>, output size <size(output)>");
	
	return output;
}

/* public map[node, set[node]] fullClassSubsumption(map[node, set[node]] input) {
	
} */


public int getNodeCountRec(node input){
	int count = 0;
	visit(input) {
		case node n:  {count += 1;}
	}
	return count;
}

/* public Statement traverseMethodImpl(loc source, Statement methodImpl) {

	str overrideVarName = "var";
	str charName = "x";
	str numVal = "1";
	Type overrideType = wildcard();

	methodImpl = visit(methodImpl) {
		case \variable(_, extraDimensions) => \variable(overrideVarName, extraDimensions)
		case \variable(_, extraDimensions, init) => \variable(overrideVarName, extraDimensions, init)
		case \characterLiteral(_) => \characterLiteral(charName)
		case \cast(_, e) => \cast(overrideType, e)
		case \number(_) => \number(numVal)
		case \type(_) => \type(overrideType)
		case \simpleName(_) => \simpleName(charName)
	}
	
	println("---------*****-----------");
	println(methodImpl);
	println("---------*****-----------");
	
	return methodImpl;
	
} */
