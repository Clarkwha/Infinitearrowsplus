@echo off
setlocal

:: Set paths
set PROJECT_NAME=InfiniteArrowsPlus
set BUILD_CONFIG=Release
set FRAMEWORK=netstandard2.1
set SOURCE_DLL=bin\%BUILD_CONFIG%\%FRAMEWORK%\%PROJECT_NAME%.dll

:: Update this path to your actual Thunderstore Mod Manager plugin directory
set PLUGIN_DEST=C:\Users\charr\AppData\Roaming\Thunderstore Mod Manager\DataFolder\Valheim\profiles\Default\BepInEx\plugins

echo Cleaning build output...
dotnet clean

echo Building project (%BUILD_CONFIG%)...
dotnet build -c %BUILD_CONFIG%

IF NOT EXIST %SOURCE_DLL% (
    echo ERROR: Build failed or DLL not found at: %SOURCE_DLL%
    pause
    exit /b 1
)

echo Copying built DLL to Thunderstore plugin folder...
xcopy /Y "%SOURCE_DLL%" "%PLUGIN_DEST%\"

echo Done.
pause
