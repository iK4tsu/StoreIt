module source.manageTitles;

import riverd.ncurses;
import std.json;
import std.file;
import std.algorithm : cmp;
import std.conv : to;
import std.string : toStringz, chomp;
import std.array : split;

import source.settings;
import source.functions;

pragma(inline, true);
void drawbox(WINDOW* manageScreen, int y, int x,
				chtype left, chtype right, chtype top, chtype bottom,
				chtype tlc, chtype blc, chtype trc, chtype brc, int vn, int hn)
{
	mvwhline(manageScreen, y, x, tlc, 1);							// top left corner
	mvwhline(manageScreen, y + vn - 1, x, blc, 1);					// bottom left corner
	mvwhline(manageScreen, y, x + hn - 1, trc, 1);					// top right corner
	mvwhline(manageScreen, y + vn - 1, x + hn - 1, brc, 1);			// bottom right corner

	mvwvline(manageScreen, y + 1, x, left, vn - 2);					// left line
	mvwvline(manageScreen, y + 1, x + hn - 1, right, vn - 2);		// right line
	mvwhline(manageScreen, y, x + 1, top, hn - 2);					// top line
	mvwhline(manageScreen, y + vn - 1, x + 1, bottom, hn - 2);		// bottom line
}

pragma(inline, true);
void drawlmanagescreen(WINDOW* manageScreen)
{
	for (int y = 1; y < 7; y++)
	{
		drawbox(manageScreen, y*3-1, 2, ACS_VLINE, ACS_VLINE, ACS_HLINE, ACS_HLINE, ACS_ULCORNER, ACS_LLCORNER, ACS_TTEE, ACS_BTEE, 3, 20);
		drawbox(manageScreen, y*3-1, 2 + 19, ACS_VLINE, ACS_VLINE, ACS_HLINE, ACS_HLINE, ACS_TTEE, ACS_BTEE, ACS_URCORNER, ACS_LRCORNER, 3, 80);
	}

	wrefresh(manageScreen);
}

bool manage(ref Mywindow manageScreen, string[] titles, ref Settings settings, int highlight, string option)
{
	auto path = settings.dir[highlight] ~ ".json";
	path = path[1 .. $];

	JSONValue j;

	Mywindow error = newWindow(6, 40, manageScreen.height / 2 - 6 / 2, manageScreen.width / 2 - 40 / 2, false);

	//path = "not";

	newBox(manageScreen.win, 0, 0);

	if (!path.exists() && cmp(option, "Add") != 0)
	{
		newBox(error.win, 0, 0);
		mvwprintcentery(error.win, error.width, error.height / 2 - 1, "File does not exist!");
		mvwprintcentery(error.win, error.width, error.height / 2, "Add a title to be able to \"" ~ option ~ "\"");
		wgetch(error.win);
		werase(error.win);
		wrefresh(manageScreen.win);
		delwin(error.win);
		return false;
	}
	else if (path.exists())
	{
		string s = to!(string)(read("./source/" ~ path));
		j = parseJSON(s);
	}
	else
	{
		string s = "{ \"AnimeDetails\":[] }";
		j = parseJSON(s);
	}

	if (cmp(option, "Add") == 0)
	{
		char[78] input;

		string blank;
		blank.length = 78;

		string single;

		string parse = "{ \"name\":\"\",
							\"id_imdb\":0,
							\"seasons\":[
								{
									\"manageScreen\":\"\",
									\"season_name\":\"\",
									\"episodes\":0,
									\"official_status\":\"\",
									\"year\":0,
									\"season_year\":\"\",
									\"status\":\"\",
									\"cur_episode\":0
								}],
							\"genre\":[]}";

		drawlmanagescreen(manageScreen.win);

		mvwprintw(manageScreen.win, 3, 3, toStringz("Name: "));
		mvwprintw(manageScreen.win, 6, 3, toStringz("Season: "));
		mvwprintw(manageScreen.win, 9, 3, toStringz("SeasonName: "));
		mvwprintw(manageScreen.win, 12, 3, toStringz("Episodes: "));
		mvwprintw(manageScreen.win, 15, 3, toStringz("Status: "));
		mvwprintw(manageScreen.win, 18, 3, toStringz("Current Episode: "));

		foreach(string title; titles)
		{
			j["AnimeDetails"].array ~= parseJSON(parse);

			mvwprintw(manageScreen.win, 3, 24, toStringz(blank));
			mvwprintw(manageScreen.win, 6, 24, toStringz(blank));
			mvwprintw(manageScreen.win, 9, 24, toStringz(blank));
			mvwprintw(manageScreen.win, 12, 24, toStringz(blank));
			mvwprintw(manageScreen.win, 15, 24, toStringz(blank));
			mvwprintw(manageScreen.win, 18, 24, toStringz(blank));

			mvwprintw(manageScreen.win, 3, 24, toStringz(title));
			wrefresh(manageScreen.win);

			wmove(manageScreen.win, 6, 24);
			single = getstring(manageScreen.win);
			j["AnimeDetails"].array[$ - 1]["seasons"].array[$ - 1]["manageScreen"].integer = to!(int)(single);

			wmove(manageScreen.win, 9, 24);
			single = getstring(manageScreen.win);
			j["AnimeDetails"].array[$ - 1]["seasons"].array[$ - 1]["season_name"].str = single;

			wmove(manageScreen.win, 12, 24);
			single = getstring(manageScreen.win);
			j["AnimeDetails"].array[$ - 1]["seasons"].array[$ - 1]["episodes"].integer = to!(int)(single);

			wmove(manageScreen.win, 15, 24);
			single = getstring(manageScreen.win);
			j["AnimeDetails"].array[$ - 1]["seasons"].array[$ - 1]["status"].str = single;

			wmove(manageScreen.win, 18, 24);
			single = getstring(manageScreen.win);
			j["AnimeDetails"].array[$ - 1]["seasons"].array[$ - 1]["cur_episode"].integer = to!(int)(single);

			j["AnimeDetails"].array[$ - 1]["name"].str = title;
		}

		write("source/" ~ path, j.toString);
	}

	//mvwprintw(manageScreen.win, 1, 1, toStringz(j["name"].str));

	return false;
}