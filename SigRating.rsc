module SigRating

data  SIG_INDEX = PLUS_PLUS() | PLUS() | ZERO() | MINUS() | MINUS_MINUS();

public int sigIndexToInt(SIG_INDEX index){
	switch(index){
		case PLUS_PLUS():
			return 5;
		case PLUS():
			return 5;
		case ZERO():
			return 3;
		case MINUS():
			return 2;
		case MINUS_MINUS():
			return 1;
		default:
			throw "Unknown type";
	}
}

public SIG_INDEX intToSigIndex(int index){
	switch(index){
		case 5:
			return PLUS_PLUS();
		case 4:
			return PLUS();
		case 3:
			return ZERO();
		case 2:
			return MINUS();
		case 1:
			return MINUS_MINUS();
		default:
			throw "Unknown type";
	}
}	