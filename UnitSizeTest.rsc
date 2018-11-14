module UnitSizeTest

import UnitSize;

loc small_test_proj = |project://smallsql0.21_src|;

/**
 * Docblock for the function that should not be counted
 */
private int fiveLineFunction() {
	// comment line 
	for (int i <- [0..0]) {
		return 0;
	}
	// whitelines and comments don't count
	
	
	// or at least they shouldn't
}

