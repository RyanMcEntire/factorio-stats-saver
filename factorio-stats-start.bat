@echo off
setlocal enabledelayedexpansion

start /B pythonw factorio_stats_watcher.pyw

start "" "C:\Program Files (x86)\Steam\steamapps\common\Factorio\bin\x64\factorio.exe"

exit /b 0
