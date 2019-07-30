module source.functions;

import riverd.ncurses;
import std.string : toStringz;
import std.process : environment;
import std.conv : to;

import source.titlesMenu;
import source.list;
import source.settings;
import source.aliasLocal : KEY;
import source.draw : drawmainmenu, drawHomeScreen, drawbarstd, updatebarstd;

/* write a sentence in the middle of a given line */
void mvwprintcentery(WINDOW* win, int width, int line, string msg)
{
	int center = width / 2 - (cast(int)msg.length / 2);
	mvwprintw(win, line, center, toStringz(msg));
}

/* write n characters in a given position horizontally */
void mvaddnchh(int y, int x, int chtype, int n)
{
	mvwaddnchh(stdscr, y, x, chtype, n);
}

void mvwaddnchh(WINDOW* win, int y, int x, int chtype, int n)
{
	for (int i = x; i < x + n; i++)
	{
		mvwaddch(win, y, i, chtype);
	}
}

/* write n characters in a given starting position vertically */
void mvaddnchv(int y, int x, int chtype, int n)
{
	mvwaddnchv(stdscr, y, x, chtype, n);
}


void mvwaddnchv(WINDOW* win, int y, int x, int chtype, int n)
{
	for (int i = y; i < y + n; i++)
	{
		mvwaddch(win, i, x, chtype);
	}
}


struct Mywindow
{
	int yVert;
	int xVert;

	int height;
	int width;

	WINDOW* win;

	int highlight = 0;
	int choice;
}


Mywindow newWindow(int height, int width, int yVert, int xVert, bool keyPad)
{
	Mywindow newwindow;

	/* new windown dimensions */
	newwindow.height = height;
	newwindow.width = width;

	/* new window position */
	newwindow.yVert = yVert;
	newwindow.xVert = xVert;

	/* creates a new invisible window */
	newwindow.win = newwin(newwindow.height, newwindow.width, yVert, xVert);

	/* turns on/off the ability to use special keys */
	keypad(newwindow.win, keyPad);

	return newwindow;
}

void newBox(WINDOW* win, int boxY, int boxX)
{
	/* draws a box arround the perimeter of the window */
	box(win, boxY, boxX);

	refresh();
	wrefresh(win);
}


string mainOptions(ref Mywindow win, ref Mywindow secondScreen, ref Mywindow titleScreen, ref Settings settings)
{
	/* print in the midle of the first line of welcome menu */
	mvwprintcentery(win.win, win.width, 1, "Welcome to your own video organizer!");
	refresh();
	wrefresh(win.win);

	string[] categories = settings.categories;
	categories ~= "Exit";

	menu1:
	while (true)
	{
		for (int i = 0; i < categories.length; i++)
		{
			/* enable background highlight for the selected option */
			if (i == win.highlight)
				wattron(win.win, WA_REVERSE);

			mvwprintw(win.win, i + 2, 1, toStringz(categories[i]));
			wmove(win.win, win.highlight + 2, 0);

			wattroff(win.win, WA_REVERSE);
		}

		win.choice = wgetch(win.win);

		/* check if the pressed key is ENTER */
		if (win.choice == 10 && win.highlight == 3)
		{
			endwin();
			return "exit";
		}
		else if(win.choice == 10)
			break;
		
		switch (win.choice)
		{
			case KEY_UP:
				win.highlight--;
				if (win.highlight < 0)
					win.highlight = 0;
				break;
			case KEY_DOWN:
				win.highlight++;
				if (win.highlight > to!(int)(categories.length - 1))
					win.highlight = to!(int)(categories.length - 1);
				break;
			default:
		}
	}

	string[4] sChoices = ["Add", "Remove", "Finish", "Return"];
	newBox(secondScreen.win, 0, 0);

	while (true)
	{
		for (int i = 0; i < sChoices.length; i++)
		{
			/* enable background highlight for the selected option */
			if (i ==  secondScreen.highlight)
				wattron(secondScreen.win, WA_REVERSE);

			mvwprintw(secondScreen.win, i + 1, 1, toStringz(sChoices[i]));
			wmove(secondScreen.win, secondScreen.highlight + 1, 0);
			wattroff(secondScreen.win, WA_REVERSE);
		}

		secondScreen.choice = wgetch(secondScreen.win);

		/* check if the pressed key is ENTER or ESC */
		if (secondScreen.choice == 27 || (secondScreen.choice == 10 && secondScreen.highlight == 3))
		{
			werase(secondScreen.win);
			wrefresh(secondScreen.win);
			secondScreen.highlight = 0;
			goto menu1;
		}
		else if (secondScreen.choice == 10)
			break;
		
		switch (secondScreen.choice)
		{
			case KEY_UP:
				secondScreen.highlight--;
				if (secondScreen.highlight < 0)
					secondScreen.highlight = 0;
				break;
			case KEY_DOWN:
				secondScreen.highlight++;
				if (secondScreen.highlight > sChoices.length - 1)
					secondScreen.highlight = sChoices.length - 1;
				break;
			default:
		}
	}

	/*
		* store file selection
		* 
		* win.highlight
		* 0 = Animes
		* 1 = Series
		* 2 = Movies
		* 
		* secondScreen.highlight
		* 0 = Add
		* 1 = Remove
		* 2 = Finish
		*/
	//if (titles.length != 0)
	//{
	//	final switch (win.highlight)
	//	{
	//		case 0:
	//			updateList(titleScreen.win, secondScreen.highlight, titles, environment.get("HOME") ~ "/my-stuff/animeList/files/animes/");
	//			break;
	//		case 1:
	//			updateList(titleScreen.win, secondScreen.highlight, titles, environment.get("HOME") ~ "/my-stuff/animeList/files/series/");
	//			break;
	//		case 2:
	//			updateList(titleScreen.win, secondScreen.highlight, titles, environment.get("HOME") ~ "/my-stuff/animeList/files/movies/");
	//			break;
	//	}
	//}
	return sChoices[secondScreen.highlight];
}

string getstring(WINDOW* win, int y, int x)
{
	import std.conv : to;
	import std.string : chomp;
	import std.array : split;

	char[78] c;

	wmove(win, y, x);

	wgetstr(win, c.ptr);
	string s = to!(string)(c);

	return (s.chomp().split("\0"))[0];
}

string getnumstring(WINDOW* win, int y, int x, string blank)
{
	import std.conv : to;
	import std.string : chomp;
	import std.array : split;
	import std.uni : isNumber;

	char[78] c;
	bool _isNumber;

	string s;

	do {
		wmove(win, y, x);

		wgetstr(win, c.ptr);
		s = to!(string)(c);

		s = (s.chomp.split("\0"))[0];

		for (int i; i < s.length; i++)
		{
			if (!s[i].isNumber)
			{
				_isNumber = false;
				mvwprintw(win, y, x, toStringz(blank));
				break;
			}
			_isNumber = true;
		}
	} while (!_isNumber);

	return s;
}


string homewindow(ref WINDOW* mainmenu, ref int mainop, ref Settings settings, WINDOW* bar)
{
	int key;
	while (true)
	{
		switch (mainop = getch())
		{
			case KEY_F(1):
				if (key != KEY_F(1))
				{
					drawbarstd(bar);
					updatebarstd(bar, 1);
					drawmainmenu(mainmenu, settings);
					
				}
				break;
			case KEY.ESC:
				return "exit";
			default:
				drawHomeScreen(bar);
		}
		key = mainop;
	}
}