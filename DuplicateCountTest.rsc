module DuplicateCountTest

import DuplicateCount;

public void testOne(){
	list[loc] locs = [|project://test/src/File1.java|,|project://test/src/File2.java|];
	findDuplicates(locs);
}