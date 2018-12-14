module Type3DetectorTest

import Type3Detector;
import IO;


public test bool testAst4_subsumedOnlyMatching_type3(){
	results = runType3detectionProject(|project://softevo_testcase_ast_4_type3|);
	println("<results>");
	return false;
}

public test bool testAst_nodup_nothing_subsumed_type3(){
	results = runType3detectionProject(|project://softevo_testcase_ast_nodup_type3|);
	println("<results>");
	return false;
}

