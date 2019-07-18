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

bool manage(ref Mywindow manageScreen, string[] titles, ref Settings settings, int highlight, string option)
{
	auto path = settings.dir[highlight] ~ ".json";
	path = path[1 .. $];

	JSONValue j;

	//path = "not";

	newBox(manageScreen.win, 0, 0);

	if (!path.exists() && cmp(option, "Add") != 0)
	{
		Mywindow error = newWindow(6, 40,
								manageScreen.height / 2 - 6 / 2,
								manageScreen.width / 2 - 40 / 2, false);
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
		string s = "{ \"AnimeDetails\":[{}] }";
		j = parseJSON(s);
	}

	if (cmp(option, "Add") == 0)
	{
		char[78] input;

		string blank;
		blank.length = 78;

		string single;

		int stdscrY, stdscrX;
		getmaxyx(stdscr, stdscrY, stdscrX);

		//WINDOW* test = newwin(3, 80, 4, 4);
		//box(test, 0, 0);
		//refresh();
		//wrefresh(test);
		//mvwprintw(test, 1, 1, "Y: %d\tX: %d", stdscrY, stdscrX);
		//wgetch(test);

		Mywindow name = newWindow(3, 80, 4, 4, true);
		Mywindow season = newWindow(3, 80, 7, 4, true);
		Mywindow seasonName = newWindow(3, 80, 10, 4, true);
		Mywindow episodes = newWindow(3, 80, 13, 4, true);
		Mywindow status = newWindow(3, 80, 16, 4, true);
		Mywindow curEp = newWindow(3, 80, 19, 4, true);

		newBox(name.win, 0, 0);
		newBox(season.win, 0, 0);
		newBox(seasonName.win, 0, 0);
		newBox(episodes.win, 0, 0);
		newBox(status.win, 0, 0);
		newBox(curEp.win, 0, 0);


		string parse = "{ \"name\":\"\",
							\"id_imdb\":0,
							\"seasons\":[
								{
									\"season\":\"\",
									\"season_name\":\"\",
									\"episodes\":0,
									\"official_status\":\"\",
									\"year\":0,
									\"season_year\":\"\",
									\"status\":\"\",
									\"episode\":0
								}],
							\"genre\":[{}]}";

		j["AnimeDetails"].array ~= parseJSON(parse);

		foreach(string title; titles)
		{
			mvwprintw(name.win, 1, 1, toStringz(blank));
			mvwprintw(season.win, 1, 1, toStringz(blank));
			mvwprintw(seasonName.win, 1, 1, toStringz(blank));
			mvwprintw(episodes.win, 1, 1, toStringz(blank));
			mvwprintw(status.win, 1, 1, toStringz(blank));
			mvwprintw(curEp.win, 1, 1, toStringz(blank));

			mvwprintw(name.win, 1, 1, toStringz("Name: "));
			mvwprintw(season.win, 1, 1, toStringz("Season: "));
			mvwprintw(seasonName.win, 1, 1, toStringz("SeasonName: "));
			mvwprintw(episodes.win, 1, 1, toStringz("Episodes: "));
			mvwprintw(status.win, 1, 1, toStringz("Status: "));
			mvwprintw(curEp.win, 1, 1, toStringz("Current Episode: "));

			mvwprintw(name.win, 1, 20, toStringz(title));

			wrefresh(name.win);
			wrefresh(season.win);
			wrefresh(seasonName.win);
			wrefresh(episodes.win);
			wrefresh(status.win);
			wrefresh(curEp.win);

			wmove(season.win, 1, 20);
			input = "";
			wgetstr(season.win, input.ptr);
			single = to!(string)(input);
			single = (single.chomp().split("\0"))[0];

			wmove(seasonName.win, 1, 20);
			input = "";
			wgetstr(seasonName.win, input.ptr);
			single = to!(string)(input);
			single = (single.chomp().split("\0"))[0];

			wmove(episodes.win, 1, 20);
			input = "";
			wgetstr(episodes.win, input.ptr);
			single = to!(string)(input);
			single = (single.chomp().split("\0"))[0];

			wmove(status.win, 1, 20);
			input = "";
			wgetstr(status.win, input.ptr);
			single = to!(string)(input);
			single = (single.chomp().split("\0"))[0];

			wmove(curEp.win, 1, 20);
			input = "";
			wgetstr(curEp.win, input.ptr);
			single = to!(string)(input);
			single = (single.chomp().split("\0"))[0];
		}
	}

	//mvwprintw(manageScreen.win, 1, 1, toStringz(j["name"].str));

	return false;
}