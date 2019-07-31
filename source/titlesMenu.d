module source.titlesMenu;

import riverd.ncurses;
import std.file : readText;
import std.string : chomp;
import std.string : toStringz;
import std.conv : to;
import std.stdio : readln, writeln;
import std.algorithm : cmp;
import std.array : split;

import source.functions;

string[] tmenu(ref Mywindow titleScreen, string sChoice)
{
	newBox(titleScreen.win, 0, 0);

	mvwprintcentery(titleScreen.win, titleScreen.width, 1, sChoice);

	/* allows the user to see his inputs */
	echo();

	/* text '~>' initial coordinates */
	int y = 3;
	int x = 1;

	/* titles in c style*/
	char[80] c;

	/* stores the conversion of char[] to a dynamic D string */
	string single;

	/* titles to add/remove/finish */
	string[] titles;

	/* erase a line */
	string blank;
	blank.length = titleScreen.width / 2 - 1;

	mvwprintw(titleScreen.win, 2, 1, "Write the titles you want to %s ('\\done' when finished'):", toStringz(sChoice));


	/* title titleScreen.window */
	while (cmp(single, "\\done") != 0)
	{
		c = "";
		mvwprintw(titleScreen.win, y, x, "~> ");
		wgetstr(titleScreen.win, c.ptr);

		single = to!(string)(c);
		single = (single.chomp().split("\0"))[0];

		switch (single)
		{
			case "\\undo":
				mvwprintw(titleScreen.win, y, x, toStringz(blank));

				if ((y > 3 && x == 1) || (x == getmaxx(titleScreen.win) / 2 && y > 3))
				{
					y--;
				}
				else if ((x == getmaxx(titleScreen.win) / 2) && y == 3)
				{
					y = getmaxy(titleScreen.win) - 2;
					x = 1;
				}
				titles = titles[0 .. $ - 1];

				mvwprintw(titleScreen.win, y, x, toStringz(blank));
				break;
			case "\\cancel":
				titles = [];
				werase(titleScreen.win);
				return titles;
			case "\\clear":
				y = 3;
				x = 1;
				werase(titleScreen.win);
				box(titleScreen.win, 0, 0);
				mvwprintcentery(titleScreen.win, titleScreen.width, 1, sChoice);
				mvwprintw(titleScreen.win, 2, 1, "Write the titles you want to %s ('\\done' when finished'):", toStringz(sChoice));
				titles = [];
				break;
			case "\\done":
				break;
			default:
				if (single.length > 0 && single[0] != '\\')
				{
					titles ~= single;
					y++;
					if (y > getmaxy(titleScreen.win) - 2 && x == 1)
					{
						y = 3;
						x = getmaxx(titleScreen.win) / 2;
					}
					else if (y > getmaxy(titleScreen.win) - 2 && x != 1)
					{
						werase(titleScreen.win);
						box(titleScreen.win, 0, 0);
						mvwprintw(titleScreen.win, 1, 1, "Cannot add more titles!");
						mvwprintw(titleScreen.win, 2, 1, "Press any key to continue...");
						wgetch(titleScreen.win);
						single = "\\done";
					}
				}
				else mvwprintw(titleScreen.win, y, x, toStringz(blank));
		}
	}

	werase(titleScreen.win);
	return titles;
}

