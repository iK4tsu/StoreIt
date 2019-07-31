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
import source.draw;
import source.aliasLocal : COLOR_PAIR, PAIR;

void main()
{
	/* TODO */
	/* system to store ones options */
	Settings settings = readSettings();


	/* init all windows and curses itself */
	WINDOW* barstdscr = initCurses();
	WINDOW* mainmenu = newwin(to!(int)(2 + settings.categories.length), 20, getbegy(barstdscr) + 1, getbegx(barstdscr) + 3);
	WINDOW* titlesopmenu = dupwin(mainmenu);


	/* init Mywindows */
	Mywindow bar = properties(barstdscr, true);
	Mywindow main = properties(mainmenu, true);
	Mywindow tltop = properties(titlesopmenu, true);


	/* all windows */
	int stdscrY, stdscrX;
	getmaxyx(stdscr, stdscrY, stdscrX);

	Mywindow titleScreen = newWindow(stdscrY - 5, stdscrX - 5, 2, 2, true);
	Mywindow manageScreen = newWindow(stdscrY - 5, stdscrX - 5, 2, 2, true);

	bool isOver = false;
	string[] titles;

	do {
		string option = homewindow(main, bar, tltop, settings);


		/* ends program */
		if (cmp(option, "exit") == 0)
			break;
		else if (cmp(option, "return") == 0)
			continue;

		/* titles to manage */
		titles = tmenu(titleScreen, option);

		/* user canceled the operation or didn't write anything */
		if (titles.length == 0)
			continue;

		isOver = manage(manageScreen, titles, settings, main.highlight, option);
	} while (!isOver);

	echo();
	curs_set(1);
	endwin();

	// testing
	//import std.stdio : writeln;
	//import std.json;
	//string s = to!(string)(read("./source/animes.json"));
	//JSONValue j = parseJSON(s);
//
	//writeln(j["AnimeDetails"].array);
	//JSONValue jj = parseJSON(j["AnimeDetails"].toString);
//
	//writeln("NAME: ", jj[0]["name"].str);
	//writeln(jj[0]["seasons"][0]["season"].integer);

	return;
}