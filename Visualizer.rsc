module Visualizer

import vis::Figure;
import vis::Render;
import vis::KeySym;

import IO;

import CloneDetector;
import DuplicationDefinitions;
import Type12Detector;

str file1code = "";
str file2code = "";
list[str] filedata = [];

public void visualizeSmall() {
	CloneReport cr = genCRforProject(|project://smallsql0.21_src|);
}

public void testThis() {
	visualizeResults(runType12detection(|project://test|));
}

public void testJSON() {
	dupResToJSON(runType12detection(|project://test|));
}

public void visualizeResults(DuplicationResults res) {
	Figure classSelector = vscrollable(vcat(genClassSelector(res)));

	divider = box(hshrink(0.01), fillColor("black"));

	codebox = box(text(str () { return file1code; }, fontSize(20), fontColor("blue"), align(0,0)), 
	hshrink(0.4),fillColor("white"));

	Figure visualized = box(hcat([classSelector,divider,codebox,divider,codebox]), 
							fillColor("black"));
	
	render(visualized);
}

public list[Figure] genClassSelector(DuplicationResults res) {
	list[Figure] classes = [];
	int counter = 0;
	
	for (dupRes <- res) {
		filedata += ["test <dupRes.duplicationCount>"];
	
		classText = text("<dupRes.duplicationCount> Duplications",
					fontSize(16), fontColor("blue"), align(0,0),
					onMouseDown(bool (int butnr, map [KeyModifier,bool] modifiers) 
					{
						file1code = filedata[counter];
						counter += 1;
						return true;
					}));
		classes += [box(classText,size(100,30),fillColor("white"))];
	}
	
	return classes;
}
