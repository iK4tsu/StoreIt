module source.manageTitles;

import riverd.ncurses;

import source.settings;
import source.functions;

bool manage(Mywindow manageScreen, string[] titles, Settings settings)
{
	newBox(manageScreen.win, 0, 0);
	wgetch(manageScreen.win);

	return false;
}