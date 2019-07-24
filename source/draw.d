module source.draw;

import riverd.ncurses;
import std.string : toStringz;

import source.aliasLocal : COLOR_PAIR, COLOR, PAIR;

void initCurses()
{
	initscr();                  // start curses
	cbreak();                   // allow user to exit with <ctrl + c>
	curs_set(0);                // hide the cursor
	noecho();                   // hide key inputs
	keypad(stdscr, true);       // allow the use of special keys

	start_color();                              // starts colors
	
	initCustomColors();                         // load personalized colors
	initColorPairs();                           // load color pairs
	

	bkgd(COLOR_PAIR(PAIR.stdscr));        // set colors of the stdscr
	attron(COLOR_PAIR(PAIR.stdscrbtn));
	mvaddstr(0, 0, toStringz("Settings"));
	attroff(COLOR_PAIR(PAIR.stdscrbtn));

	refresh();
	//getch();
	return;
}


/* personalized colors */
void initCustomColors()
{
	init_color(COLOR.silver, 753, 753, 753);
	init_color(COLOR.grey, 502, 502, 502);
	init_color(COLOR.lightgrey, 827, 827, 827);
	return;
}


/* color pairs */
void initColorPairs()
{
	/* id, foreground, background */
	init_pair(PAIR.stdscr, COLOR_BLACK, COLOR.grey);
	init_pair(PAIR.stdscrbtn, COLOR_BLACK, COLOR.lightgrey);
	return;
}