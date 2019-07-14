module source.functions;

import riverd.ncurses;
import std.string : toStringz;

/* write a sentence in the middle of a given line */
void mvwprintcentery(WINDOW* win, int width, int line, string msg)
{
	int center = width / 2 - (cast(int)msg.length / 2);
	mvwprintw(win, line, center, toStringz(msg));
}


struct Mywindow
{
	int yMax;
	int xMax;

	int height;
	int width;

	WINDOW* win;

	int highlight = 0;
}


Mywindow newWindow(int height, int width, int yVert, int xVert, bool keyPad)
{
	Mywindow newwindow;

	/* screen size */
	getmaxyx(stdscr, newwindow.yMax, newwindow.xMax);

	/* new windown dimensions */
	newwindow.height = newwindow.yMax - height;
	newwindow.width = newwindow.xMax - width;

	/* creates a new invisible window */
	newwindow.win = newwin(newwindow.height, newwindow.width, yVert, xVert);

	/* draws a box arround the perimeter of the window */
	box(newwindow.win, 0, 0);

	/* turns on/off the ability to use special keys */
	keypad(newwindow.win, keyPad);

	refresh();
	wrefresh(newwindow.win);

	return newwindow;
}