module dbtable;

import d2sqlite3;

void inittables(ref Database moviesdb, ref Database seriesdb, Database animesdb)
{
	moviesdb.run("CREATE TABLE IF NOT EXISTS movies (
					ID              INTEGER PRIMARY KEY,
					NAME            TEXT NOT NULL,
					IMDB_ID         INTEGER,
					DESCRIPTION     TEXT NOT NULL,
					GENRE           TEXT NOT NULL,
					YEAR_RELEASE    INTEGER,
					LENGTH          INTEGER)"
	);

	seriesdb.run("CREATE TABLE IF NOT EXISTS series (
					ID              INTEGER PRIMARY KEY,
					NAME            TEXT NOT NULL,
					IMDB_ID         INTEGER,
					DESCRIPTION     TEXT NOT NULL,
					GENRE           TEXT NOT NULL,
					YEAR_RELEASE    INTEGER,
					LENGTH          INTEGER,
					SEASONS         INTEGER,
					SEASON          INTEGER,
					EPISODES        INTEGER,
					EPISODE         INTEGER,
					OFFICIAL_STATUS TEXT NOT NULL,
					STATUS          TEXT NOT NULL,
					NEXT_EPISODE    TEXT NOT NULL)"
	);

	animesdb.run("CREATE TABLE IF NOT EXISTS animes (
					ID              INTEGER PRIMARY KEY,
					NAME            TEXT NOT NULL,
					IMDB_ID         INTEGER,
					DESCRIPTION     TEXT NOT NULL,
					GENRE           TEXT NOT NULL,
					YEAR_RELEASE    INTEGER,
					LENGTH          INTEGER,
					SEASONS         INTEGER,
					SEASON          INTEGER,
					EPISODES        INTEGER,
					EPISODE         INTEGER,
					OFFICIAL_STATUS TEXT NOT NULL,
					STATUS          TEXT NOT NULL,
					NEXT_EPISODE    TEXT NOT NULL)"
	);
}