module source.draw;

import riverd.ncurses;
import std.string : toStringz;

import source.aliasLocal : COLOR_PAIR, COLOR, PAIR;
import source.functions : mvaddnchh, mvaddnchv, mvwaddnchh, mvwaddnchv;
import source.settings : Settings;

WINDOW* initCurses()
{
	initscr();                  // start curses
	cbreak();                   // allow user to exit with <ctrl + c>
	curs_set(0);                // hide the cursor
	noecho();                   // hide key inputs
	keypad(stdscr, true);       // allow the use of special keys
	set_escdelay(0);

	start_color();                              // starts colors
	
	initCustomColors();                         // load personalized colors
	initColorPairs();                           // load color pairs
	
	WINDOW* barstdscr = newwin(1, getmaxx(stdscr) - 2, 3, 1);		// top bar
	drawHomeScreen(barstdscr);

	return barstdscr;
}


/* personalized colors */
void initCustomColors()
{
	init_color(COLOR.silver, 753, 753, 753);
	init_color(COLOR.grey, 502, 502, 502);
	init_color(COLOR.lightgrey, 827, 827, 827);
	init_color(COLOR.prussianblue, 0, 192, 325);
	init_color(COLOR.capri, 0, 749, 1_000);
	
	init_color(COLOR.blackrussian, 102, 102, 114);
	init_color(COLOR.claret, 435, 133, 196);
	init_color(COLOR.tyrianpurple, 459, 27, 251);
	init_color(COLOR.cardinal, 765, 27, 247);
	init_color(COLOR.gunpowder, 306, 306, 314);

	init_color(COLOR.blackrussian2, 43, 47, 63);
	init_color(COLOR.bunker, 122, 157, 200);
	init_color(COLOR.linkwater, 773, 776, 780);
	init_color(COLOR.babyblue, 400, 988, 945);
	init_color(COLOR.bluechill, 271, 635, 620);
	init_color(COLOR.blackpearl, 98, 125, 161);
}


/* color pairs */
void initColorPairs()
{
	/* id, foreground, background */
	init_pair(PAIR.stdscr, COLOR.blackrussian2, COLOR.bunker);
	init_pair(PAIR.stdscrbtn, COLOR.babyblue, COLOR.bunker);
	init_pair(PAIR.stdscrbtn2, COLOR.linkwater, COLOR.bunker);

	init_pair(PAIR.barstdscr, COLOR.bluechill, COLOR.bunker);
	init_pair(PAIR.barstdsmb, COLOR.babyblue, COLOR.bunker);
	init_pair(PAIR.barstdtxt, COLOR.linkwater, COLOR.bunker);
	init_pair(PAIR.barstdslct, COLOR.cardinal, COLOR.blackpearl);
	init_pair(PAIR.barstdtxtslct, COLOR.linkwater, COLOR.blackpearl);

	init_pair(PAIR.mainmenu, COLOR.linkwater, COLOR.bunker);

	//init_pair(10, COLOR.tyrianpurple, COLOR_BLACK);
	//init_pair(11, COLOR.cardinal, COLOR_BLACK);
}


/* use this when updating home screen */
void drawHomeScreen(WINDOW* win)
{
	attron(COLOR_PAIR(PAIR.stdscr));
	fillwindow(stdscr, ACS_CKBOARD);
	attroff(COLOR_PAIR(PAIR.stdscr));

	drawStoreIt();

	drawbarstd(win);

	refresh();
	wrefresh(win);
}


/* draw 'STOREIT' in the stdscr */
void drawStoreIt()
{
	attron(COLOR_PAIR(PAIR.stdscrbtn));
	
	/* draw S */
	mvaddnchh(getmaxy(stdscr) / 2 - 12, getmaxx(stdscr) / 2 - 50, ACS_BLOCK, 10);	// top line
	mvaddnchv(getmaxy(stdscr) / 2 - 12, getmaxx(stdscr) / 2 - 50, ACS_BLOCK, 5);	// upper left line
	mvaddnchv(getmaxy(stdscr) / 2 - 12, getmaxx(stdscr) / 2 - 49, ACS_BLOCK, 5);	// upper left line
	mvaddnchh(getmaxy(stdscr) / 2 - 8, getmaxx(stdscr) / 2 - 50, ACS_BLOCK, 10);		// middle line
	mvaddnchv(getmaxy(stdscr) / 2 - 8, getmaxx(stdscr) / 2 - 41, ACS_BLOCK, 5);		// lower right line
	mvaddnchv(getmaxy(stdscr) / 2 - 8, getmaxx(stdscr) / 2 - 42, ACS_BLOCK, 5);		// lower tight line
	mvaddnchh(getmaxy(stdscr) / 2 - 4, getmaxx(stdscr) / 2 - 50, ACS_BLOCK, 10);		// bottom line

	/* draw T */
	mvaddnchh(getmaxy(stdscr) / 2 - 12, getmaxx(stdscr) / 2 - 36, ACS_BLOCK, 10);
	mvaddnchv(getmaxy(stdscr) / 2 - 12, getmaxx(stdscr) / 2 - 32, ACS_BLOCK, 9);
	mvaddnchv(getmaxy(stdscr) / 2 - 12, getmaxx(stdscr) / 2 - 31, ACS_BLOCK, 9);

	/* draw O */
	mvaddnchh(getmaxy(stdscr) / 2 - 12, getmaxx(stdscr) / 2 - 22, ACS_BLOCK, 10);
	mvaddnchv(getmaxy(stdscr) / 2 - 12, getmaxx(stdscr) / 2 - 22, ACS_BLOCK, 9);
	mvaddnchv(getmaxy(stdscr) / 2 - 12, getmaxx(stdscr) / 2 - 21, ACS_BLOCK, 9);
	mvaddnchv(getmaxy(stdscr) / 2 - 12, getmaxx(stdscr) / 2 - 13, ACS_BLOCK, 9);
	mvaddnchv(getmaxy(stdscr) / 2 - 12, getmaxx(stdscr) / 2 - 12, ACS_BLOCK, 9);
	mvaddnchh(getmaxy(stdscr) / 2 - 4, getmaxx(stdscr) / 2 - 22, ACS_BLOCK, 10);

	/* draw R */
	mvaddnchh(getmaxy(stdscr) / 2 - 12, getmaxx(stdscr) / 2 - 7, ACS_BLOCK, 10);
	mvaddnchv(getmaxy(stdscr) / 2 - 12, getmaxx(stdscr) / 2 - 7, ACS_BLOCK, 9);
	mvaddnchv(getmaxy(stdscr) / 2 - 12, getmaxx(stdscr) / 2 - 6, ACS_BLOCK, 9);
	mvaddnchv(getmaxy(stdscr) / 2 - 12, getmaxx(stdscr) / 2 + 1, ACS_BLOCK, 3);
	mvaddnchv(getmaxy(stdscr) / 2 - 12, getmaxx(stdscr) / 2 + 2, ACS_BLOCK, 3);
	mvaddch(getmaxy(stdscr) / 2 - 9, getmaxx(stdscr) / 2 + 1, ACS_BLOCK);
	mvaddch(getmaxy(stdscr) / 2 - 9, getmaxx(stdscr) / 2, ACS_BLOCK);
	mvaddnchh(getmaxy(stdscr) / 2 - 8, getmaxx(stdscr) / 2 - 7, ACS_BLOCK, 8);
	mvaddch(getmaxy(stdscr) / 2 - 7, getmaxx(stdscr) / 2 + 1, ACS_BLOCK);
	mvaddch(getmaxy(stdscr) / 2 - 7, getmaxx(stdscr) / 2, ACS_BLOCK);
	mvaddnchv(getmaxy(stdscr) / 2 - 6, getmaxx(stdscr) / 2 + 2, ACS_BLOCK, 3);
	mvaddnchv(getmaxy(stdscr) / 2 - 6, getmaxx(stdscr) / 2 + 1, ACS_BLOCK, 3);

	/* draw E */
	mvaddnchh(getmaxy(stdscr) / 2 - 12, getmaxx(stdscr) / 2 + 8, ACS_BLOCK, 10);
	mvaddnchv(getmaxy(stdscr) / 2 - 12, getmaxx(stdscr) / 2 + 8, ACS_BLOCK, 9);
	mvaddnchv(getmaxy(stdscr) / 2 - 12, getmaxx(stdscr) / 2 + 9, ACS_BLOCK, 9);
	mvaddnchh(getmaxy(stdscr) / 2 - 8, getmaxx(stdscr) / 2 + 8, ACS_BLOCK, 10);
	mvaddnchh(getmaxy(stdscr) / 2 - 4, getmaxx(stdscr) / 2 + 8, ACS_BLOCK, 10);

	/* draw I */
	mvaddnchh(getmaxy(stdscr) / 2 - 12, getmaxx(stdscr) / 2 + 23, ACS_BLOCK, 10);
	mvaddnchv(getmaxy(stdscr) / 2 - 12, getmaxx(stdscr) / 2 + 27, ACS_BLOCK, 9);
	mvaddnchv(getmaxy(stdscr) / 2 - 12, getmaxx(stdscr) / 2 + 28, ACS_BLOCK, 9);
	mvaddnchh(getmaxy(stdscr) / 2 - 4, getmaxx(stdscr) / 2 + 23, ACS_BLOCK, 10);

	/* draw T */
	mvaddnchh(getmaxy(stdscr) / 2 - 12, getmaxx(stdscr) / 2 + 38, ACS_BLOCK, 10);
	mvaddnchv(getmaxy(stdscr) / 2 - 12, getmaxx(stdscr) / 2 + 42, ACS_BLOCK, 9);
	mvaddnchv(getmaxy(stdscr) / 2 - 12, getmaxx(stdscr) / 2 + 43, ACS_BLOCK, 9);

	refresh();
}


/* fill a window with a chracter */
void fillwindow(WINDOW* win, int chtype)
{
	for (int i = 0; i < getmaxy(win); i++)
	{
		mvwaddnchh(win, i, 0, chtype, getmaxx(win));
	}
}


/* draw stdscr bar */
void drawbarstd(WINDOW* win)
{
	wbkgd(win, COLOR_PAIR(PAIR.stdscr));

	wattron(win, WA_BOLD);								// make characters thicker

	wattron(win, COLOR_PAIR(PAIR.barstdsmb));			// atribute on
	mvwaddch(win, 0, 4, ACS_DIAMOND);
	wattroff(win, COLOR_PAIR(PAIR.barstdsmb));			// atribute off

	wattron(win, COLOR_PAIR(PAIR.barstdtxt));
	mvwaddstr(win, 0, 5, toStringz(" Menu"));
	wattroff(win, COLOR_PAIR(PAIR.barstdtxt));

	wattroff(win, WA_BOLD);
	
	wrefresh(win);
}


void updatebarstd(WINDOW* win, int pos)
{
	final switch (pos)
	{
		case 1:
			wattron(win, COLOR_PAIR(PAIR.barstdslct | WA_BOLD));
			mvwaddch(win, 0, 4, ACS_DIAMOND);
			wattroff(win, COLOR_PAIR(PAIR.barstdslct | WA_BOLD));
			
			wattron(win, COLOR_PAIR(PAIR.barstdtxtslct | WA_BOLD));
			mvwaddstr(win, 0, 5, toStringz(" Menu"));
			wattroff(win, COLOR_PAIR(PAIR.barstdtxtslct | WA_BOLD));
			break;
	}
	wrefresh(win);
}


/* drop down menu */
void drawmainmenu(WINDOW* win, Settings settings)
{
	werase(win);

	import std.conv : to;
	wbkgd(win, COLOR_PAIR(PAIR.mainmenu));

	wattron(win, COLOR_PAIR(PAIR.barstdscr));
	mvwhline(win, 0, 0, '=', getmaxx(win));
	wattroff(win, COLOR_PAIR(PAIR.barstdscr));

	wattron(win, COLOR_PAIR(PAIR.mainmenu) | WA_BOLD);

	foreach(i, string cat; settings.categories)
	{
		wattron(win, COLOR_PAIR(PAIR.barstdscr));
		mvwhline(win, to!(int)(i + 1), 0, '=', getmaxx(win));
		wrefresh(win);
		delay_output(50);
		wattron(win, COLOR_PAIR(PAIR.mainmenu) | WA_BOLD);
		mvwaddnchh(win, to!(int)(i + 1), 0, ' ', getmaxx(win));
		mvwaddch(win, to!(int)(i + 1), 1, ACS_BULLET);
		mvwaddstr(win, to!(int)(i + 1), 3, toStringz(cat));
	}

	wattron(win, COLOR_PAIR(PAIR.barstdscr));
	mvwhline(win, getmaxy(win) - 1, 0, '=', getmaxx(win));
	wattroff(win, COLOR_PAIR(PAIR.barstdscr));

	wattroff(win, WA_BOLD);

	wrefresh(win);
}

void mainWinShadowWin(ref WINDOW* main, ref WINDOW* shadow)
{
	wbkgd(shadow, COLOR_PAIR(10));
	wattron(shadow, COLOR_PAIR(11));

	import std.conv : to;
	for (int i = 0; i < getmaxy(shadow); i++)
	{
		for (int j = 0; j < getmaxx(shadow); j++)
		{
			mvwaddnstr(shadow, i, j, toStringz("."), getmaxx(shadow));
		}
	}

	wattroff(shadow, COLOR_PAIR(11));
	wbkgd(main, COLOR_PAIR(PAIR.mainmenu));
	box(main, 0, 0);

	refresh();
	wrefresh(shadow);
	wrefresh(main);
}