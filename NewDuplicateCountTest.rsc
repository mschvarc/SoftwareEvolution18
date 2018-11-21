module NewDuplicateCountTest

import NewDuplicateCount;


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



public test bool testTwoDuplicateFiles50percent(){
	list[loc] locs = [|project://test/src/tests/File1.java|,|project://test/src/tests/File2.java|];
	result = getDupRatio(locs);
	return result.lineCount == 24 && result.duplicateLines == 7;
}

public test bool testDuplicatesSameFileTwice(){
	list[loc] locs = [|project://test/src/tests/File1.java|,|project://test/src/tests/File1.java|];
	result = getDupRatio(locs);
	return result.lineCount == 24 && result.duplicateLines == 12;
}

public test bool testDuplicatesSameFileOnlyWithX(){
	list[loc] locs = [|project://test/src/tests/File4.java|];
	result = getDupRatio(locs);
	return result.lineCount == 13 && result.duplicateLines == 6;
}

public test bool testDuplicatesSameFileOnlyDuplciatedBlock(){
	list[loc] locs = [|project://test/src/tests/File5.java|];
	result = getDupRatio(locs);
	return result.lineCount == 12 && result.duplicateLines == 6;
}

public test bool testNoDuplicateFiles(){
	list[loc] locs = [|project://test/src/tests/File1.java|,|project://test/src/tests/File3.java|];
	result = getDupRatio(locs);
	return result.lineCount == 24 && result.duplicateLines == 0;
}


