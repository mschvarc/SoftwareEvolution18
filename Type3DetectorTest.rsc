module Type3DetectorTest

import Type3Detector;
import IO;
import Type123Shared;
import List;
import Set;


public test bool testAst4_subsumedOnlyMatching_type3(){
	results = transformResultsForWeb(
	runDuplicationCheckerProjectType3(|project://softevo_testcase_ast_4_type3|,12));
	return size(results) == 1 && size(results[0].fileLocations) == 2;
}

public test bool testAst_nodup_nothing_subsumed_type3(){
	results = transformResultsForWeb(
	runDuplicationCheckerProjectType3(|project://softevo_testcase_ast_nodup_type3|,12));
	return size(results) == 0;
}

