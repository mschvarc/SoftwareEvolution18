package tests;
/*
module tests::UnitSizeTest

import UnitSize;

loc small_test_proj = |project://smallsql0.21_src|;
*/

public class UnitSizeTest
{
	/**
	 * Docblock for the function that should not be counted
	 */
	private int fiveLineFunction(int arg1) {
		// comment line 
		for (int i = 0; i < 0; i++) {
			return 0;
		}
		// whitelines and comments don't count
	
	
		// or at least they shouldn't
		
		switch(arg1) {
		case 1:
			break;
		case 2:
			break;
		default:
			break;
	}
		return -1;
	}
	
}
