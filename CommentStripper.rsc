module CommentStripper


import IO;

import List;
import String;


import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import analysis::m3::AST;

public list[str] convertToLines(str line){
	return split("\n", line);
}

public list[str] stripEmptyLineAndComments(list[str] lines){

	bool inComment = false;
	list[str] result = [];
	
	for(rawLine <- lines) {
		str trimmedLine = trim(rawLine);
		if(trimmedLine == ""){
			continue;
		}
		if(startsWith(trimmedLine, "/*")){
			inComment = true;
		}
		if(endsWith(trimmedLine, "*/")){
			inComment = false;
			continue; //do not append comment line itself
		}
		//skip single line comments directly
		if(startsWith(trimmedLine, "//")){
			continue;
		}
		if(inComment){
			continue;
		}
		result += trimmedLine;
	}
	return result;
}