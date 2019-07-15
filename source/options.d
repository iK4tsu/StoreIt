module source.options;

import std.file : exists, mkdir;
import std.process : environment;

struct Options
{
	string files;
	string[] dir;
}

Options defaultSettings()
{
	Options op;

	/* home path: "/home/whoami" */
	immutable auto home = environment.get("HOME");

	op.files = home ~ "/my-stuff/animeList/files";
	if (!op.files.exists())
	{
		mkdir(op.files);
		mkdir(op.files ~ "/animes");
		mkdir(op.files ~ "/series");
		mkdir(op.files ~ "/movies");

		op.dir ~= "/animes" ~ "/series" ~ "/movies";
	}

	return op;
}