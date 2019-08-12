module dataManagement;

import functions;
import draw : drawHomeScreen, fillwindow, drawmanagewindow;
import aliasLocal : COLOR, COLOR_PAIR, PAIR;

import d2sqlite3;
import riverd.ncurses;


void animeData(ref Database db, string op, Mywindow mngop, Mywindow barmng)
{
	final switch (op)
	{
		case "Add":
			addData(db, mngop, barmng);
			break;
		
		case "Remove":
		case "Finish":
	}
}

void addData(ref Database db, Mywindow mngop, Mywindow barmng)
{
	drawmanagewindow(mngop.win, barmng.win);
	getch();
}