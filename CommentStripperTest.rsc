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

public bool testNoCommentsFile(){
	lines = readFileLines(|project://test2/src/tests/File1.java|);
	newLines = stripEmptyLineAndComments(lines);
	return size(newLines) == 12;
}

public bool testSingleLineCommentsFile(){
	lines = readFileLines(|project://test2/src/tests/SingleLineComments.java|);
	newLines = stripEmptyLineAndComments(lines);
	return size(newLines) == 9;
}

public bool testMultilineCommentsMixedFile(){
	lines = readFileLines(|project://test2/src/tests/MixedMultiLineComments.java|);
	newLines = stripEmptyLineAndComments(lines);
	println(newLines);
	return size(newLines) == 9;
}