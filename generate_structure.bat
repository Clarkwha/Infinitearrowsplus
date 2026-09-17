@echo off
setlocal

REM Change directory to the folder where this BAT file is located
cd /d "%~dp0"

REM Output file structure to a text file
echo Generating file structure...
tree /f > structure.txt

echo Done. The file structure has been saved to structure.txt
pause
