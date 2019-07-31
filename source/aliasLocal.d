module source.aliasLocal;

import riverd.ncurses;

import source.functions;

/* special keys */
struct KEYS
{
	static immutable int ENTER = 10;
	static immutable int ESC = 27;
}

/* special keys alias */
alias KEY = KEYS;


/* statfun function conflit */
alias COLOR_PAIR = riverd.ncurses.types.COLOR_PAIR;
alias waddstr = riverd.ncurses.inline.waddstr;


/* personalized color id's */
struct COLORS
{
	static immutable int silver = 16;
	static immutable int grey = 17;
	static immutable int lightgrey = 18;
	static immutable int prussianblue = 19;
	static immutable int capri = 20;
	
	/* comtemporary and bold */
	static immutable int blackrussian = 21;
	static immutable int claret = 22;
	static immutable int tyrianpurple = 23;
	static immutable int cardinal = 24;
	static immutable int gunpowder = 25;

	/* striking and simple */
	static immutable int blackrussian2 = 26;
	static immutable int bunker = 27;
	static immutable int linkwater = 28;
	static immutable int babyblue = 29;
	static immutable int bluechill = 30;
	static immutable int blackpearl = 31;
}

/* personalized color alias */
alias COLOR = COLORS;


/* color pair id's */
struct PAIRS
{
	static immutable int stdscr = 1;			// standard screen
	static immutable int stdscrbtn = 2;			// standard screen buttons
	static immutable int stdscrbtn2 = 3;		// statdard screen button color 2

	static immutable int barstdscr = 6;			// main bar
	static immutable int barstdsmb = 7;			// bar diamond symbol
	static immutable int barstdtxt = 8;			// bar text
	static immutable int barstdslct = 9;		// bar selection
	static immutable int barstdtxtslct = 10;	// bar text selection
	
	static immutable int mainmenu = 11;			// main menu window
	static immutable int mainmenubtn = 12;		// main menu buttons
	static immutable int mainmenubtnslct = 13;	// main menu button selection
}

/* color pair alias */
alias PAIR = PAIRS;