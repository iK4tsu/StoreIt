module source.functions;

import riverd.ncurses;
import std.string : toStringz;
import std.process : environment;

import source.titlesMenu;
import source.list;

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
	int choice;
}


Mywindow newWindow(int height, int width, int yVert, int xVert, bool keyPad)
{
	Mywindow newwindow;

	/* new windown dimensions */
	newwindow.height = height;
	newwindow.width = width;

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


string mainOptions(ref Mywindow win, ref Mywindow secondScreen, ref Mywindow titleScreen)
{
	/* print in the midle of the first line of welcome menu */
	mvwprintcentery(win.win, win.width, 1, "Welcome to your own video organizer!");
	refresh();
	wrefresh(win.win);

	string[4] vChoices = ["Animes", "Series", "Movies", "Exit"];

	menu1:
	while (true)
	{
		for (int i = 0; i < vChoices.length; i++)
		{
			/* enable background highlight for the selected option */
			if (i == win.highlight)
				wattron(win.win, WA_REVERSE);

			mvwprintw(win.win, i + 2, 1, toStringz(vChoices[i]));
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
				if (win.highlight > vChoices.length - 1)
					win.highlight = vChoices.length - 1;
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

		/* check if the pressed key is ENTER */
		if (secondScreen.choice == 10 && secondScreen.highlight == 3)
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