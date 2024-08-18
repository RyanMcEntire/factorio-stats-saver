# factorio-stats-saver

I'm using an out of the box server provider that is hosting my factorio server.

The stats_collection.lua script is loaded by the server on game startup and runs in game to periodically write the production and consumption stats to file.

stats_db_ingestion.py is set to run and update the DB whenever a change is made. It starts up when the server is run and ends when the game server shuts down.
