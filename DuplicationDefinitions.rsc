module DuplicationDefinitions

import IO;
import List;

alias DuplicationResult = tuple[int duplicationCount, list[loc] fileLocations];
alias DuplicationResults = list[DuplicationResult];
alias DuplicateMap = map[node, set[node]];

data DuplicationType = TYPE_ONE() | TYPE_TWO() | TYPE_THREE();


alias CloneReport = map[str, set[tuple[loc path, list[int] indices]]];

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
		jsonChunk += "{\"loc\" : \"<fileLOC>\", \"content\" : 
						\"<intercalate("\\\\n", readFileLines(fileLOC))>\"},";
	}	

	return jsonChunk[..-1] + "] },";
}

