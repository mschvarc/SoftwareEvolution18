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

/*

https://stackoverflow.com/questions/47555798/comparing-ast-nodes


*/



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
	
	//ast = unset(ast);
		
	println(ast);
}

//returns complexity as a number
public void traverseMethodImpl(loc source, Statement methodImpl) {

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
	
	//println(methodImpl);
	
}
