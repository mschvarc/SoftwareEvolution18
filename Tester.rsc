module Tester

import vis::Figure;
import vis::Render; 

import vis::KeySym;

public void do() {
s = "";
s2 = "";
b = box(text(str () { return s; }),
	fillColor("red"),
	onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
		s = "<butnr>";
		return true;
	}));
b2 = box(vcat([
	text(str () { return s2; }),
	b],shrink(0.7)),
	fillColor("green"),
	onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
		s2 = "<butnr>";
		return true;
	}));
render(b2);
}