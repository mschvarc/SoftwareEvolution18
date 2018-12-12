module Visualizer

import vis::Figure;
import vis::Render;

import CloneDetector;

public void visualizeSmall() {
	CloneReport cr = genCRforProject(|project://smallsql0.21_src|);
}

public void __init__() {
	actText = text("Rascal", fontSize(20), fontColor("blue"), align(0,0));

	divider = box(hshrink(0.01), fillColor("black"));

	textbox = box(actText, size(100,500), fillColor("white"));
	doubleTest = vscrollable(vcat(getFive()));
	codebox = box(hshrink(0.4),fillColor("green"));
	filebox = box(hshrink(0.4),fillColor("blue"));

	bg = box(hcat([doubleTest,divider,codebox,divider,filebox]), fillColor("black"));
	
	render(bg);
}

public list[Figure] getFive() {
	actText = text("TEST", fontSize(20), fontColor("blue"), align(0,0));
	oneBox = box(actText, size(100,200), fillColor("white"));
	return [oneBox,oneBox,oneBox,oneBox,oneBox];
}
