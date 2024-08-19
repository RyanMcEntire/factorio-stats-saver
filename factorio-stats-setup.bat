@echo off

color 06

echo .           
echo .           d88888b  .d8b.   .o88b. d888888b  .d88b.  d8888b. d888888b  .d88b.  
echo .           88'     d8' `8b d8P  Y8 `~~88~~' .8P  Y8. 88  `8D   `88'   .8P  Y8. 
echo .           88ooo   88ooo88 8P         88    88    88 88oobY'    88    88    88 
echo .           88~~~   88~~~88 8b         88    88    88 88`8b      88    88    88 
echo .           88      88   88 Y8b  d8    88    `8b  d8' 88 `88.   .88.   `8b  d8' 
echo .           YP      YP   YP  `Y88P'    YP     `Y88P'  88   YD Y888888P  `Y88P'  
echo .                                                                                
echo .                                                                               
echo .                     .d8888. d888888b  .d8b.  d888888b .d8888.                 
echo .                     88'  YP `~~88~~' d8' `8b `~~88~~' 88'  YP                 
echo .                     `8bo.      88    88ooo88    88    `8bo.                   
echo .                       `Y8b.    88    88~~~88    88      `Y8b.                 
echo .                     db   8D    88    88   88    88    db   8D                 
echo .                     `8888Y'    YP    YP   YP    YP    `8888Y'                 
echo .                                                                               

REM Check if Python is installed
python --version
IF %ERRORLEVEL% NEQ 0 (
    echo Python is not installed. Installing Python...
    
    REM Download the Python installer
    curl -o python_installer.exe https://www.python.org/ftp/python/3.10.0/python-3.10.0-amd64.exe
    
    REM Install Python silently with PATH added
    python_installer.exe /quiet InstallAllUsers=1 PrependPath=1
    
    REM Clean up the installer
    del python_installer.exe
)

REM Check Python installation again to ensure it was installed correctly
python --version
IF %ERRORLEVEL% NEQ 0 (
    echo Python installation failed. Exiting...
    pause
    exit /b 1
)

echo Python is installed.

REM Install pip if not available
pip --version
IF %ERRORLEVEL% NEQ 0 (
    echo pip is not available. Installing pip...
    
    REM Install pip using get-pip.py
    curl -o get-pip.py https://bootstrap.pypa.io/get-pip.py
    python get-pip.py
    
    REM Clean up
    del get-pip.py
)

REM Install required Python packages
echo Installing required Python packages...
pip install requests watchdog

color 06

echo .
echo                                    .',,,,,,'..                        
echo                                   .;dxooool:'.                        
echo                                   .:xdc::::,...                       
echo                     ..'..      ...,oko:::::,......     ..,'..         
echo                   .'lxo,'....,:loddddc:::::;;:cc:,'...'cxxc'...       
echo                 .'lxkoc;;,,cdxxollc::::::::::::cccc:;cxkxoc;,'..      
echo                 .;loc::::;:llc:::::::::::::::::::cccclolccc:;'...     
echo                  ..,;:::::::::::::::;;;;;;;;:::::::cc:cccc:,'...      
echo                    .:olc::::::::;,,''.......'',,;:::cc:cc:,...        
echo                   .;xko::::::;,'................',;::cccc:;'...       
echo                  .;xko:::::;,'....             ..',:::c:cc:;'...      
echo                  'dko:::::;,....                 ..;ccc:ccc:;'..      
echo           ..''',,lkdc:::::,...                     .:llc:ccc:,',,,''..
echo           .cdooooool:::::;'..                      .'loc:cccc::loool;.
echo           .lxlc::::::::::,...                       .coc::ccccccccc;..
echo           .lxc:::::::::::,...                       .oxl::ccccccc::,..
echo           .;:'''',;::::::;'..                      .;xxc:cccc:,,'''...
echo           .......,ll::::::,...                    .,xOdccccc:,........
echo                  .clc::::::,....                ..;dOdccccc:,'..      
echo                  .'ccc::::::;''....           ..,okxlccccc:;'..       
echo                   .':cc:::::::;;;;,'.......',:ldxdoc::ccc:;'..        
echo                   .,oxo:::::::::::cccllloodxkxdoc:::::ccc:,...        
echo                 ..cxkdc::::::::::::::ccccccccc::::::cccccc:,'....     
echo                 .;ool::::;,,,;:::::::::::::::::::::;;;;:ccc:,'...     
echo                 ..',;;;,'.....',,;;;::::::::::;;,,'...',;::,'...      
echo                   ...''............,:::::::;,'..........'''...        
echo                     ....        ...:dl::::;,....        ....          
echo                                   .:do::::;'...                       
echo                                   .,c;'''''...                        
echo                                    ...........                        
echo . 
color 06

echo Setup is complete. You can now run the game using the factorio-stats-start.bat file.
pause
exit