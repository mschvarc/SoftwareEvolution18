module CommentStripperTest

import IO;
import List;
import String;
import IO;
import List;
import String;
import IO;
import List;
import Set;
import Relation;
import Map;
import String;
import util::Math;
import util::Resources;
import List;
import String;

import CommentStripper;

public test bool testNoCommentsFile(){
	lines = readFileLines(|project://series1/src/tests/File1.java|);
	newLines = stripEmptyLineAndComments(lines);
	//println(newLines);
	return size(newLines) == 12;
}

public test  bool testSingleLineCommentsFile(){
	lines = readFileLines(|project://series1/src/tests/SingleLineComments.java|);
	newLines = stripEmptyLineAndComments(lines);
	//println(newLines);
	return size(newLines) == 10 && newLines[8] == "w";
}

public test bool testMultilineCommentsMixedFile(){
	lines = readFileLines(|project://series1/src/tests/MixedMultiLineComments.java|);
	newLines = stripEmptyLineAndComments(lines);
	//println(newLines);
	return size(newLines) == 14;
}