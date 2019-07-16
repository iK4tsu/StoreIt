module source.app;

import riverd.ncurses;
import std.string : toStringz;
import std.file;
import std.conv : to;
import std.process : environment;
import std.algorithm : cmp;

import source.titlesMenu;
import source.list;
import source.functions;
import source.settings;
import source.manageTitles;

void main()
{
	/* initialize ncurses */
	initscr();
	noecho();
	cbreak();

	/* TODO */
	/* system to store ones options */
	Settings settings = defaultSettings();

	/* all windows */
	Mywindow mainScreen = newWindow(5, 5, 2, 2, true);
	Mywindow secondScreen = newWindow(50, 200, 4, 10, true);
	Mywindow titleScreen = newWindow(5, 5, 2, 2, true);
	Mywindow manageScreen = newWindow(5, 5, 2, 2, true);

	bool isOver = false;
	string[] titles;

	do {
		newBox(mainScreen.win, 0, 0);
		string option = mainOptions(mainScreen, secondScreen, titleScreen);

		/* ends program */
		if (cmp(option, "exit") == 0)
			break;

		/* titles to manage */
		titles = tmenu(titleScreen, option);

		/* user canceled the operation or didn't write anything */
		if (titles.length == 0)
			continue;

		isOver = manage(manageScreen, titles, settings);
	} while (!isOver);

	echo();
	curs_set(1);
	endwin();

	import std.stdio : writeln;
	writeln(titles);

	return;
}