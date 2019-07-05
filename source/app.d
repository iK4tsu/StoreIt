module source.app;

import riverd.ncurses;
import std.string : toStringz;
import std.file : readText;
import std.conv : to;
import std.process : environment;

import source.titlesMenu;
import source.list;

/* write a sentence in the middle of a given line */
void mvwprintcentery(WINDOW* win, int width, int line, int x, string msg)
{
	int center = (width + x) / 2 - (cast(int)msg.length / 2);
	mvwprintw(win, line, center, toStringz(msg));
}

void main()
{
	/* initialize ncurses */
	initscr();
	noecho();
	cbreak();

	/* get window size */
	int yMax, xMax;
	getmaxyx(stdscr, yMax, xMax);

	/* welcome window coordinates */
	int height = yMax - 5;
	int width = xMax - 5;

	/* create welcome menu window */
	WINDOW* wMenu = newwin(height, width, 2, 2);
	box(wMenu, 0, 0);

	/* refresh main screen to acknowledge the new window */
	refresh();

	/* enable use of keyboard */
	keypad(wMenu, true);

	/* print in the midle of the first line of welcome menu */
	mvwprintcentery(wMenu, width, 1, 2, "Welcome to your own video organizer!");
	wrefresh(wMenu);


	string[4] vChoices = ["Animes", "Series", "Movies", "Exit"];
	int highlight = 0;

	menu1:
	while (true)
	{
		for (int i = 0; i < vChoices.length; i++)
		{
			/* enable background highligh for the selected option */
			if (i ==  highlight)
				wattron(wMenu, WA_REVERSE);

			mvwprintw(wMenu, i + 2, 1, toStringz(vChoices[i]));
			wmove(wMenu, highlight + 2, 0);
			wattroff(wMenu, WA_REVERSE);
		}

		int choice = wgetch(wMenu);

		/* check if the pressed key is ENTER */
		if (choice == 10 && highlight == 3)
		{
			endwin();
			return;
		}
		else if(choice == 10)
			break;
		
		switch (choice)
		{
			case KEY_UP:
				highlight--;
				if (highlight < 0)
					highlight = 0;
				break;
			case KEY_DOWN:
				highlight++;
				if (highlight > vChoices.length - 1)
					highlight = vChoices.length - 1;
				break;
			default:
		}
	}

	/* create the selection window */
	WINDOW* sMenu = newwin(height / 4, width / 10, 4, 10);
	box(sMenu, 0, 0);

	refresh();
	wrefresh(sMenu);

	keypad(sMenu, true);

	string[4] sChoices = ["Add", "Remove", "Finish", "Return"];
	int shighlight = 0;

	while (true)
	{
		for (int i = 0; i < sChoices.length; i++)
		{
			/* enable background highligh for the selected option */
			if (i ==  shighlight)
				wattron(sMenu, WA_REVERSE);

			mvwprintw(sMenu, i + 1, 1, toStringz(sChoices[i]));
			wmove(sMenu, shighlight + 1, 0);
			wattroff(sMenu, WA_REVERSE);
		}

		int choice = wgetch(sMenu);

		/* check if the pressed key is ENTER */
		if (choice == 10 && shighlight == 3)
		{
			werase(sMenu);
			wrefresh(sMenu);
			delwin(sMenu);
			goto menu1;
		}
		else if (choice == 10)
			break;
		
		switch (choice)
		{
			case KEY_UP:
				shighlight--;
				if (shighlight < 0)
					shighlight = 0;
				break;
			case KEY_DOWN:
				shighlight++;
				if (shighlight > sChoices.length - 1)
					shighlight = sChoices.length - 1;
				break;
			default:
		}
	}

	/* create a new generic window */
	WINDOW* gMenu = newwin(height - 8, width - 30, 6, 20);
	box(gMenu, 0, 0);
	
	refresh();
	wrefresh(gMenu);

	keypad(gMenu, true);

	mvwprintcentery(gMenu, width - 30, 1, 0, sChoices[shighlight]);

	/* every title to add/remove/finish */
	string[] titles = tmenu(gMenu, sChoices[shighlight]);

	/*
	 * store file selection
	 * 
	 * highlight
	 * 0 = Animes
	 * 1 = Series
	 * 2 = Movies
	 * 
	 * shighlight
	 * 0 = Add
	 * 1 = Remove
	 * 2 = Finish
	 */
	final switch (highlight)
	{
		case 0:
			updateList(gMenu, shighlight, titles, environment.get("HOME") ~ "/my-stuff/animeList/files/animes/");
			break;
		case 1:
			updateList(gMenu, shighlight, titles, environment.get("HOME") ~ "/my-stuff/animeList/files/series/");
			break;
		case 2:
			updateList(gMenu, shighlight, titles, environment.get("HOME") ~ "/my-stuff/animeList/files/movies/");
			break;
	}

	werase(gMenu);
	delwin(gMenu);
	endwin();

	return;
}