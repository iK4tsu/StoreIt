module settings;

import std.file : exists, mkdir, getcwd, write, read;
import std.process : environment;
import std.conv : to;
import std.json;
import std.string : strip, capitalize;
import riverd.ncurses;
import std.stdio : writeln, readln;


struct Settings
{
	string cwd;
	string[] categories;
}

Settings defaultSettings()
{
	Settings op;

	/* default settings */
	string s = "{\"programDirectory\": \"\", \"categories\": [\"Animes\", \"Movies\", \"Series\"]}";
	JSONValue j = parseJSON(s);

	/* pwd path: "/home/whoami/program" */
	immutable string cwd = getcwd();

	/* save work directory */
	op.cwd = cwd;

	/* save default categories */
	op.categories ~= "Animes";
	op.categories ~= "Movies";
	op.categories ~= "Series";
	
	/* check for a not existent 'files' directory */
	if (!(cwd ~ "/files").exists())
		mkdir(cwd ~ "/files");

	/* insert work directory in the settings file */
	j["programDirectory"] = cwd;

	/* save file */
	write(cwd ~ "/settings.json", j.toString);

	writeln("Thank you for trying StoreIt as your new video library!");
	writeln("It is recomended you use a terminal with 255 color support.");
	writeln("Terminals that do not have this support will display the wrong colors, making readability much harder and bad for your precious eyes!");
	writeln("Terminal recomendation: kitty.");
	writeln("Because the program was made using 'kitty' as a visual reference, this is the terminal recomended for the use of the application.");
	writeln("However, as long as your terminal supports all, or almost all, of the features implemented, you are free to use any terminal you want.");
	writeln("Have fun, and StoreIt!");
	writeln("Press any key to continue...");
	readln();

	return op;
}

Settings readSettings()
{
	/* get current work directory */
	immutable string cwd = getcwd();

	/* check for a not existing file */
	if (!(cwd ~ "/settings.json").exists())
		return defaultSettings();


	string sjson = to!(string)(read(cwd ~ "/settings.json"));
	JSONValue j = parseJSON(sjson);

	
	Settings set;
	
	/* save existing work directory */
	set.cwd = cwd;

	/* save user categories */
	foreach(JSONValue str; j["categories"].array)
		set.categories ~= capitalize(strip(str.toString, "\"\""));

	return set;
}

//Settings customSettings(Settings settings)
//{
//	WINDOW* customSettings = newwin(50, 50, 25, 25);
//	box(customSettings, 0, 0);
//
//	start_color();
//	init_pair(1, COLOR_BLUE, COLOR_WHITE);
//}