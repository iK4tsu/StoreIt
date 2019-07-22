module source.settings;

import std.file : exists, mkdir, getcwd;
import std.process : environment;
import std.conv : to;

struct Settings
{
	string files;
	string[] dir;
}

Settings defaultSettings()
{
	Settings op;

	/* home path: "/home/whoami" */
	immutable string home = getcwd();

	op.files = home ~ "/files";
	if (!op.files.exists())
	{
		mkdir(op.files);
		mkdir(op.files ~ "/animes");
		mkdir(op.files ~ "/series");
		mkdir(op.files ~ "/movies");
	}

	op.dir ~= "/animes";
	op.dir ~= "/series";
	op.dir ~= "/movies";

	return op;
}