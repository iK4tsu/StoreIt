module source.app;

import riverd.ncurses;
import d2sqlite3;
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
import dbtable;

void main()
{
	/* TODO */
	/* system to store ones options */
	Settings settings = readSettings();


	/* init all windows and curses itself */
	WINDOW* barstdscr = initCurses();
	WINDOW* mainmenu = newwin(to!(int)(2 + settings.categories.length), 20, getbegy(barstdscr) + 1, getbegx(barstdscr) + 3);
	WINDOW* titleopmenu = newwin(5, 20, getbegy(mainmenu), getbegx(mainmenu));
	WINDOW* fileopmenu = newwin(5, 20, getbegy(mainmenu), getbegx(barstdscr) + 18);


	/* init Mywindows */
	Mywindow bar = properties(barstdscr, true);
	Mywindow main = properties(mainmenu, true);
	Mywindow tltop = properties(titleopmenu, true);
	Mywindow fileop = properties(fileopmenu, true);


	/* all windows */
	int stdscrY, stdscrX;
	getmaxyx(stdscr, stdscrY, stdscrX);

	Mywindow titleScreen = newWindow(stdscrY - 5, stdscrX - 5, 2, 2, true);
	Mywindow manageScreen = newWindow(stdscrY - 5, stdscrX - 5, 2, 2, true);

	bool isOver = false;
	string[] titles;

	/* init db tables */
	auto moviesdb = Database("./movies.db");
	auto seriesdb = Database("./series.db");
	auto animesdb = Database("./animes.db");

	inittables(moviesdb, seriesdb, animesdb);


	do {
		string option = homewindow(main, bar, tltop, fileop, settings);


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