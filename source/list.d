module list;

import riverd.ncurses;
import std.algorithm : canFind, sort, remove;
import std.file : write, readText, append;
import std.string : toStringz, chomp;
import std.conv : to;
import std.array : split;
import std.stdio : writeln;

void resetWindow(WINDOW* win, int* y, int* x)
{
	werase(win);
	box(win, 0, 0);
	wrefresh(win);

	*y = 1;
	*x = 1;
}

void updateList(WINDOW* win, immutable int sChoice, string[] titles, immutable string path)
{
	noecho();
	curs_set(1);
	
	int y, x;
	resetWindow(win, &y, &x);
	
	
	/* all paths */
	immutable string current = path ~ "current.txt";
	immutable string removed = path ~ "removed.txt";
	immutable string finished = path ~ "finished.txt";

	string[] fileInfo = to!(string[])(readText(current).chomp.split("\n"));

	final switch (sChoice)
	{
		wgetch(win);
		case 0:
			foreach(string title; titles)
			{
				mvwprintw(win, y, x, "Checking %s... ", toStringz(title));
				delay_output(30);
				wrefresh(win);

				if (!canFind(fileInfo, title))
				{
					wprintw(win, "title added.");
					fileInfo ~= title;
				}
				else
					wprintw(win, "title already exists!");
				
				y++;
				if (y > getmaxy(win) - 2)
				{
					y = 1;
					x = getmaxx(win) / 2;
				}
			}
			fileInfo.sort();
			
			foreach(string title; fileInfo)
			{
				title ~= "\n";
				append(current, title);
			}
			break;
		case 1:
			string[] rmv = to!(string[])((readText(removed)).chomp.split("\n"));
			foreach(string title; titles)
			{
				mvwprintw(win, y, x, "Checking %s... ", toStringz(title));
				delay_output(30);
				wrefresh(win);
				
				if (canFind(fileInfo, title))
				{
					wprintw(win, "title removed.");
					rmv ~= title;
					fileInfo = remove!(a => a == title)(fileInfo);
				}
				else
					wprintw(win, "title does not exist!");

				y++;
				if (y > getmaxy(win) - 2)
				{
					y = 1;
					x = getmaxx(win) / 2;
				}
			}
			fileInfo.sort();
			rmv.sort();

			foreach(string title; fileInfo)
			{
				title ~= "\n";
				append(current, title);
			}

			foreach(string title; rmv)
			{
				title ~= "\n";
				append(removed, title);
			}
			break;
		case 2:
			string[] fnsh = to!(string[])((readText(finished)).chomp.split("\n"));
			foreach(string title; titles)
			{
				mvwprintw(win, y, x, "Checking %s... ", toStringz(title));
				delay_output(30);
				wrefresh(win);

				if (!canFind(fnsh, title))
				{
					wprintw(win, "title does not exist. Finish anyway? (y/n)");
					int ch = wgetch(win);

					label:
					switch (ch)
					{
						case 'y':
						case 10:
							fnsh ~= title;
							fileInfo = remove!(a => a == title)(fileInfo);
							break;
						case 'n':
							break;
						default:
							goto label;
					}
				}
				else
				{
					wprintw(win, "title finished.");
					fnsh ~= finished;
					fileInfo = remove!(a => a == title)(fileInfo);
				}

				y++;
				if (y > getmaxy(win) - 2)
				{
					y = 1;
					x = getmaxx(win) / 2;
				}
			}
			fileInfo.sort();
			fnsh.sort();

			foreach(string title; fileInfo)
			{
				title ~= "\n";
				append(current, title);
			}

			foreach(string title; fnsh)
			{
				title ~= "\n";
				append(finished, title);
			}

			break;
	}

	wgetch(win);
	return;
}