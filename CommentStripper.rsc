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
		trimmedLine = stripEmbeddedQuotes(trimmedLine);
		trimmedLine = stripEmbeddedComments(trimmedLine);
		if(trimmedLine == ""){
			continue;
		}
		if(startsWith(trimmedLine, "//")){
			continue;
		}
		//parse multiline comments last
		if(contains(trimmedLine, "/*")){
			inComment = true;
		}
		if(contains(trimmedLine, "*/") && inComment){
			inComment = false;
			//remove everything to the left of */
			if(/\*\/<right:.*>/ := trimmedLine){
				trimmedLine = right;
			}
		}
		
		if(inComment){
			continue;
		}
		if(trimmedLine != "") {
			result += trimmedLine;
		}
	}
	return result;
}

public str stripEmbeddedQuotes(str line) {
	while(/<left:.*>\".*\"<right:.*>/ := line) {
		line = left + right;
	}
	return line;
}

public str stripEmbeddedComments(str line){
	while(/<left:.*>\/\*.*\*\/<right:.*>/ := line) {
		line = left + right;
	}
	return line;
}
