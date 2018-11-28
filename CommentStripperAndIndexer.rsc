module CommentStripperAndIndexer

import IO;
import List;
import String;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import analysis::m3::AST;

/**
* Converts a single line to multi line array based on line endings
* @param input
* @return original string split on newline
*/
public list[str] convertToLines(str line){
	return split("\n", line);
}

/**
* Function to remove all whitespace only lines and comments
* @param lines input
* @return lines stripped of whitespace and comments, indexed by their line number
*/
public list[tuple[int,str]] stripAndIndex(list[str] lines){

	bool inComment = false;
	list[tuple[int,str]] result = [];
	
	for(i <- [0..(size(lines))]) {
		rawLine = lines[i];
		
		str trimmedLine = trim(rawLine);
		str searchLine = stripEmbeddedComments(trimmedLine);
		
		if(searchLine == ""){
			continue;
		}
		//NOTE: if a single line comment contains /* or */ , it must be ignored per Java grammar
		if(startsWith(trimmedLine, "//")){
			continue;
		}
		//remove comment side : code // comment --> code
		if(/<left:.*>\/\/.*/ := searchLine){
			searchLine = left;
		}
		
		//parse multiline comments last
		if(contains(searchLine, "/*")){
			inComment = true;
		}
		if(contains(searchLine, "*/") && inComment){
			inComment = false;
			//remove everything to the left of */
			if(/\*\/<right:.*>/ := searchLine){
				searchLine = right;
			}
		}
		if(inComment){
			continue;
		}
		if(searchLine != "") {
			//add modified line to result, do 1 more trim
			result += <i+1, trim(searchLine)>;
		}
	}
	return result;
}

private str stripEmbeddedQuotes(str line) {
	while(/<left:.*>\".*\"<right:.*>/ := line) {
		line = left + right;
	}
	return line;
}

private str stripEmbeddedComments(str line){
	while(/<left:.*>\/\*.*\*\/<right:.*>/ := line) {
		line = left + right;
	}
	return line;
}
