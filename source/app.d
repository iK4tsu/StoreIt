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

enum ENTER = 10;
enum ESC = 27;

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
	int stdscrY, stdscrX;
	getmaxyx(stdscr, stdscrY, stdscrX);

	Mywindow mainScreen = newWindow(stdscrY - 5, stdscrX - 5, 2, 2, true);
	Mywindow secondScreen = newWindow(6, stdscrX - 200, 4, 10, true);
	Mywindow titleScreen = newWindow(stdscrY - 5, stdscrX - 5, 2, 2, true);
	Mywindow manageScreen = newWindow(stdscrY - 5, stdscrX - 5, 2, 2, true);

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

		isOver = manage(manageScreen, titles, settings, mainScreen.highlight, option);
	} while (!isOver);

	echo();
	curs_set(1);
	endwin();

	// testing
	import std.stdio : writeln;
	import std.json;
	string s = to!(string)(read("./source/animes.json"));
	JSONValue j = parseJSON(s);

	writeln(j["AnimeDetails"].array);
	JSONValue jj = parseJSON(j["AnimeDetails"].toString);

	writeln("NAME: ", jj[0]["name"].str);
	writeln(jj[0]["seasons"][0]["season"].integer);

	return;
}