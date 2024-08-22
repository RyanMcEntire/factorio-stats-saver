@echo off
setlocal enabledelayedexpansion

REM Start the Python watcher script silently
start /B pythonw factorio_stats_watcher.pyw

REM Start Factorio (adjust the path as needed)
start "" "C:\Program Files (x86)\Steam\steamapps\common\Factorio\bin\x64\factorio.exe"

exit /b 0
