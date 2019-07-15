module source.app;

import riverd.ncurses;
import std.string : toStringz;
import std.file;
import std.conv : to;
import std.process : environment;

import source.titlesMenu;
import source.list;
import source.functions;
import source.options;

void main()
{
	/* initialize ncurses */
	initscr();
	noecho();
	cbreak();

	/* TODO */
	/* system to store ones options */
	Options options = defaultSettings();

	/* all windows */
	Mywindow mainScreen = newWindow(5, 5, 2, 2, true);
	Mywindow secondScreen = newWindow(50, 200, 4, 10, true);
	Mywindow titleScreen = newWindow(5, 5, 2, 2, true);

	do {
		newBox(mainScreen.win, 0, 0);
		mainOptions(mainScreen, secondScreen, titleScreen);
	} while (mainScreen.highlight != 3);

	echo();
	curs_set(1);
	endwin();

	return;
}