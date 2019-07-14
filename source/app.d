module source.app;

import riverd.ncurses;
import std.string : toStringz;
import std.file : readText;
import std.conv : to;
import std.process : environment;

import source.titlesMenu;
import source.list;
import source.functions;

void main()
{
	/* initialize ncurses */
	initscr();
	noecho();
	cbreak();

	Mywindow mainScreen = newWindow(5, 5, 2, 2, true);

	/* print in the midle of the first line of welcome menu */
	mvwprintcentery(mainScreen.win, mainScreen.width, 1, "Welcome to your own video organizer!");
	wrefresh(mainScreen.win);

	string[4] vChoices = ["Animes", "Series", "Movies", "Exit"];

	menu1:
	while (true)
	{
		for (int i = 0; i < vChoices.length; i++)
		{
			/* enable background highlight for the selected option */
			if (i == mainScreen.highlight)
				wattron(mainScreen.win, WA_REVERSE);

			mvwprintw(mainScreen.win, i + 2, 1, toStringz(vChoices[i]));
			wmove(mainScreen.win, mainScreen.highlight + 2, 0);
			wattroff(mainScreen.win, WA_REVERSE);
		}

		int choice = wgetch(mainScreen.win);

		/* check if the pressed key is ENTER */
		if (choice == 10 && mainScreen.highlight == 3)
		{
			endwin();
			return;
		}
		else if(choice == 10)
			break;
		
		switch (choice)
		{
			case KEY_UP:
				mainScreen.highlight--;
				if (mainScreen.highlight < 0)
					mainScreen.highlight = 0;
				break;
			case KEY_DOWN:
				mainScreen.highlight++;
				if (mainScreen.highlight > vChoices.length - 1)
					mainScreen.highlight = vChoices.length - 1;
				break;
			default:
		}
	}

	Mywindow secondScreen = newWindow(50, 200, 4, 10, true);

	string[4] sChoices = ["Add", "Remove", "Finish", "Return"];

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

		int choice = wgetch(secondScreen.win);

		/* check if the pressed key is ENTER */
		if (choice == 10 && secondScreen.highlight == 3)
		{
			werase(secondScreen.win);
			wrefresh(secondScreen.win);
			delwin(secondScreen.win);
			goto menu1;
		}
		else if (choice == 10)
			break;
		
		switch (choice)
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

	Mywindow titleScreen = newWindow(5, 5, 2, 2, true);

	mvwprintcentery(titleScreen.win, titleScreen.width, 1, sChoices[secondScreen.highlight]);

	/* every title to add/remove/finish */
	string[] titles = tmenu(titleScreen.win, sChoices[secondScreen.highlight]);

	/*
	 * store file selection
	 * 
	 * mainScreen.highlight
	 * 0 = Animes
	 * 1 = Series
	 * 2 = Movies
	 * 
	 * secondScreen.highlight
	 * 0 = Add
	 * 1 = Remove
	 * 2 = Finish
	 */
	final switch (mainScreen.highlight)
	{
		case 0:
			updateList(titleScreen.win, secondScreen.highlight, titles, environment.get("HOME") ~ "/my-stuff/animeList/files/animes/");
			break;
		case 1:
			updateList(titleScreen.win, secondScreen.highlight, titles, environment.get("HOME") ~ "/my-stuff/animeList/files/series/");
			break;
		case 2:
			updateList(titleScreen.win, secondScreen.highlight, titles, environment.get("HOME") ~ "/my-stuff/animeList/files/movies/");
			break;
	}

	werase(titleScreen.win);
	delwin(titleScreen.win);
	endwin();

	return;
}