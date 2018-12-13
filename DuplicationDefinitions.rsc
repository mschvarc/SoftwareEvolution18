module DuplicationDefinitions

import IO;
import List;
import String;

alias DuplicationResult = tuple[int duplicationCount, list[loc] fileLocations];
alias DuplicationResults = list[DuplicationResult];
alias DuplicateMap = map[node, set[node]];

data DuplicationType = TYPE_ONE() | TYPE_TWO() | TYPE_THREE();


alias CloneReport = map[str, set[tuple[loc path, list[int] indices]]];

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

