module source.functions;

import riverd.ncurses;
import std.string : toStringz;
import std.process : environment;
import std.conv : to;
import std.algorithm : cmp;

import source.titlesMenu;
import source.list;
import source.settings;
import source.aliasLocal : KEY;
import source.draw : drawmainmenu, drawHomeScreen, drawbarstd, updatebarstd, updatemainmenu, drawtitleopmenu, updatetitleopmenu;

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


Mywindow properties(ref WINDOW* win, bool keyPad)
{
	Mywindow ret;

	ret.win = win;
	ret.height = getmaxy(win);
	ret.width = getmaxx(win);
	ret.yVert = getbegy(win);
	ret.xVert = getbegx(win);

	keypad(win, keyPad);                    // ability to use keys

	return ret;
}


void newBox(WINDOW* win, int boxY, int boxX)
{
	/* draws a box arround the perimeter of the window */
	box(win, boxY, boxX);

	refresh();
	wrefresh(win);
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


string homewindow(ref Mywindow main, ref Mywindow bar, ref Mywindow tltop, ref Mywindow fileop, ref Settings settings)
{
	int key;
	drawHomeScreen(bar.win);
	while (true)
	{
		switch (key = getch())
		{
			case KEY_F(1):
				if (bar.choice != KEY_F(1))
				{
					bar.choice = 1;
					drawbarstd(bar.win);
					updatebarstd(bar.win, bar.choice);
					drawmainmenu(main.win, settings);
					return mainWindow(main, bar, tltop, settings);
				}
				break;

			case KEY_F(2):
				if (bar.choice != KEY_F(2))
				{
					bar.choice = 2;
					drawbarstd(bar.win);
					updatebarstd(bar.win, bar.choice);
				} 
				break;

			case KEY_F(3):
				if (bar.choice != KEY_F(3))
				{
					bar.choice = 3;
					drawbarstd(bar.win);
					updatebarstd(bar.win, bar.choice);
				}
				break;

			case KEY.ESC:
				return "exit";
			default:
		}
		bar.choice = key;
	}
}


string mainWindow(ref Mywindow main, ref Mywindow bar, ref Mywindow tltop, ref Settings settings)
{
	while (true)
	{
		switch (main.choice = getch())
		{
			case KEY.ESC:
				main.highlight = 0;
				drawHomeScreen(bar.win);
				return "return";

			case KEY_DOWN:
				main.highlight++;
				if (main.highlight > getmaxy(main.win) - 2)
					main.highlight = getmaxy(main.win) - 2;
				drawmainmenu(main.win, settings, false);
				updatemainmenu(main.win, main.highlight);
				break;

			case KEY_UP:
				main.highlight--;
				if (main.highlight < 1)
					main.highlight = 1;
				drawmainmenu(main.win, settings, false);
				updatemainmenu(main.win, main.highlight);
				break;

			case KEY.ENTER:
				if (main.highlight < 1)
				{
					main.highlight = 1;
					updatemainmenu(main.win, main.highlight);
				}
				drawtitleopmenu(tltop.win, main.highlight);
				string s = titleopWindow(main, bar, tltop, settings);
				if (cmp(s, "return") == 0) break;
				else
				{
					main.highlight = 0;
					return s;
				}

			default:
				if (main.highlight < 1)
				{
					main.highlight = 1;
					updatemainmenu(main.win, main.highlight);
				}
		}
	}
}


string titleopWindow(ref Mywindow main, ref Mywindow bar, ref Mywindow tltop, ref Settings settings)
{
	while (true)
	{
		switch (tltop.choice = getch())
		{
			case KEY.ESC:
				tltop.highlight = 0;
				mvwin(tltop.win, getbegy(tltop.win) - main.highlight - 1, getbegx(tltop.win));
				drawHomeScreen(bar.win);
				updatebarstd(bar.win, bar.choice);
				drawmainmenu(main.win, settings, false);
				updatemainmenu(main.win, main.highlight);
				return "return";

			case KEY_DOWN:
				tltop.highlight++;
				if (tltop.highlight > getmaxy(tltop.win) - 2)
					tltop.highlight = getmaxy(tltop.win) - 2;
				mvwin(tltop.win, getbegy(tltop.win) - main.highlight - 1, getbegx(tltop.win));
				drawtitleopmenu(tltop.win, main.highlight, false);
				updatetitleopmenu(tltop.win, tltop.highlight);
				break;

			case KEY_UP:
				tltop.highlight--;
				if (tltop.highlight < 1)
					tltop.highlight = 1;
				mvwin(tltop.win, getbegy(tltop.win) - main.highlight - 1, getbegx(tltop.win));
				drawtitleopmenu(tltop.win, main.highlight, false);
				updatetitleopmenu(tltop.win, tltop.highlight);
				break;

			case KEY.ENTER:
				if (tltop.highlight < 1)
				{
					tltop.highlight = 1;
					updatemainmenu(tltop.win, tltop.highlight);
				}
				mvwin(tltop.win, getbegy(tltop.win) - main.highlight - 1, getbegx(tltop.win));
				final switch (tltop.highlight)
				{
					case 1:
						tltop.highlight = 0;
						return "Add";
					case 2:
						tltop.highlight = 0;
						return "Remove";
					case 3:
						tltop.highlight = 0;
						return "Finish";
				}

			default:
				if (tltop.highlight < 1)
				{
					tltop.highlight = 1;
					updatemainmenu(tltop.win, tltop.highlight);
				}
		}
	}
}