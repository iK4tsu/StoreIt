module source.titlesMenu;

import riverd.ncurses;
import std.file : readText;
import std.string : chomp;
import std.string : toStringz;
import std.conv : to;
import std.stdio : readln, writeln;
import std.algorithm : cmp;
import std.array : split;

string[] tmenu(WINDOW* win, string sChoice)
{
	/* allow the user to see his inputs */
	echo();


	/* text '~>' initial coordinates */
	int y = 3;
	int x = 1;

	/* string to store titles in c style*/
	char[80] c;

	/* string to store the conversion of char[] to a dynamic D string */
	string single;

	/* stores all the titles to add/remove/finish */
	string[] titles;


	mvwprintw(win, 2, 1, "Write the titles you want to %s (write '\\done' when finished'):", toStringz(sChoice));


	/* title window */
	while (cmp(single, "\\done") != 0)
	{
		c = "";
		mvwprintw(win, y, x, "~> ");
		wgetstr(win, c.ptr);

		single = to!(string)(c);
		single = (single.chomp().split("\0"))[0];

		switch (single)
		{
			case "\\undo":
				if ((y > 3 && x == 1) || (x == getmaxx(win) / 2 && y > 3))
				{
					y--;
					titles[$ - 1] = null;
				}
				else if ((x == getmaxx(win) / 2) && y == 3)
				{
					y = getmaxy(win) - 2;
					x = 1;
					titles[$ - 1] = null;
				}
				break;
			case "\\cancel":
				single = "\\done";
				titles[0 .. $] = null;
				break;
			case "\\clear":
				y = 3;
				x = 1;
				titles[0 .. $] = null;
				break;
			case "\\done":
				break;
			default:
				titles ~= single;
				y++;
				if (y > getmaxy(win) - 2 && x == 1)
				{
					y = 3;
					x = getmaxx(win) / 2;
				}
				else if (y > getmaxy(win) - 2 && x != 1)
				{
					werase(win);
					box(win, 0, 0);
					mvwprintw(win, 1, 1, "Cannot add more titles!");
					mvwprintw(win, 2, 1, "Press any key to continue...");
					wgetch(win);
					single = "\\done";
				}
		}
	}

	return titles;
}

