package tests;

public class ValidJavaFile {
	
	public void testMethod1(int arg1) {
		
		if(arg1 == 10) {
			return;
		}
		switch(arg1) {
			case 1:
				break;
			case 2:
				break;
			default:
				break;
		}
		return;
	}
}