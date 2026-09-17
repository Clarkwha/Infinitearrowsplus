@echo off
setlocal EnableDelayedExpansion

REM ─────────────────────────────────────────────────
REM  CONFIGURATION
REM ─────────────────────────────────────────────────
set "PROJECT_NAME=InfiniteArrowsPlus"
set "BUILD_CONFIG=Release"
set "FRAMEWORK=netstandard2.1"
set "SOURCE_DLL=bin\%BUILD_CONFIG%\%FRAMEWORK%\%PROJECT_NAME%.dll"

REM Update this if your profile folder is named something else
set "PLUGIN_DEST=%APPDATA%\Thunderstore Mod Manager\DataFolder\Valheim\profiles\Default\BepInEx\plugins"

REM ─────────────────────────────────────────────────
REM  1) Grab version_number from manifest.json
REM ─────────────────────────────────────────────────
for /f "usebackq tokens=*" %%v in (`powershell -NoProfile -Command ^
  "(Get-Content manifest.json | ConvertFrom-Json).version_number" 2^>nul`) do (
  set "VERSION=%%v"
)
if not defined VERSION (
  echo ✗ Could not read version_number from manifest.json
  pause & exit /b 1
)
echo Packaging v!VERSION!...

REM ─────────────────────────────────────────────────
REM  2) Build the project
REM ─────────────────────────────────────────────────
echo [1/3] Building...
dotnet clean -c %BUILD_CONFIG%
dotnet build -c %BUILD_CONFIG% || (
  echo ✗ Build failed.
  pause & exit /b 1
)

if not exist "%SOURCE_DLL%" (
  echo ✗ DLL not found at %SOURCE_DLL%
  pause & exit /b 1
)

REM ─────────────────────────────────────────────────
REM  3) Deploy the DLL to Thunderstore’s plugins folder
REM ─────────────────────────────────────────────────
echo [2/3] Deploying DLL to:
echo     "%PLUGIN_DEST%"
if not exist "%PLUGIN_DEST%" (
  echo ✗ Plugin folder not found!
  pause & exit /b 1
)
copy /Y "%SOURCE_DLL%" "%PLUGIN_DEST%\%PROJECT_NAME%.dll" >nul
if errorlevel 1 (
  echo ✗ Failed to copy DLL.
  pause & exit /b 1
) else (
  echo ✓ DLL deployed.
)

REM ─────────────────────────────────────────────────
REM  4) Zip up only the 4 files Thunderstore needs:
REM     manifest.json, README.md, icon.png, and the DLL
REM ─────────────────────────────────────────────────
set "ZIP_NAME=%PROJECT_NAME%-%VERSION%-valheim.zip"
echo [3/3] Zipping into "%ZIP_NAME%"...
if exist "%ZIP_NAME%" del "%ZIP_NAME%"

REM if your icon file is currently named icon.png.png, rename it once here
if exist "icon.png.png" ren "icon.png.png" "icon.png"

powershell -NoProfile -Command ^
  "Compress-Archive -Path 'manifest.json','README.md','icon.png','%SOURCE_DLL%' -DestinationPath '%ZIP_NAME%' -Force"

if exist "%ZIP_NAME%" (
  echo ✓ Created %ZIP_NAME%
) else (
  echo ✗ ZIP creation failed.
  pause & exit /b 1
)

echo.
echo All done!
pause
