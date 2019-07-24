module source.aliasLocal;

import riverd.ncurses;

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
}

/* personalized color alias */
alias COLOR = COLORS;


/* color pair id's */
struct PAIRS
{
	static immutable int stdscr = 1;
	static immutable int stdscrbtn = 2;
}

/* color pair alias */
alias PAIR = PAIRS;