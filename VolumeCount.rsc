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

import CommentStripper;


public void VCrunOnProject(){
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
	return;
}


//TODO: refactor
public list[loc] getIndividualJavaFiles(loc project) {
	return [f | /file(f) := getProject(project), f.extension == "java"];
}


public int getLinesOfCode(loc location) {
	list[str] rawLines = readFileLines(location);
	list[str] lines = stripEmptyLineAndComments(rawLines);
	return size(lines);
}

