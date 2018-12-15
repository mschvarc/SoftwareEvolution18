module JsonWriter

import DuplicationDefinitions;
import IO;
import List;
import Map;
import Node;
import Relation;
import Set;
import String;
import Type12Detector;
import Type123Shared;
import Type3Detector;
import analysis::m3::AST;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::m3::Core;
import util::Math;
import util::Resources;

str NEWLINEENCODER = "*3df6f7c89eeb58cc*";

public void dupResToJSON(loc writeLocation, DuplicationResults dupRes) {
	str result = "[";
	
	for (res <- dupRes) {
		result += singleDupResToJSON(res);
	}
	
	result = result[..-1] + "]";
	
	writeFile(writeLocation, [result]);
}

public str singleDupResToJSON(DuplicationResult dupRes) {
	str jsonChunk = "{\"dupCount\" : <dupRes.duplicationCount>, \"LOCs\" : [ ";
	
	for (fileLOC <- dupRes.fileLocations) {
		str preparedContent = replaceAll(intercalate("<NEWLINEENCODER>", readFileLines(fileLOC)),"\t","\\t");
		jsonChunk += "{\"loc\" : \"<fileLOC>\", \"content\" : \"<preparedContent>\"},";
	}	

	return jsonChunk[..-1] + "] },";
}