@echo off

REM Run from this script's directory so relative paths work from any shell.
pushd "%~dp0"

REM Git
copy /Y ".gitconfig" "%USERPROFILE%\.gitconfig"

REM VS Code
copy /Y "vscode\keybindings.json" "%APPDATA%\Code\User\keybindings.json"
copy /Y "vscode\settings.json" "%APPDATA%\Code\User\settings.json"

REM Neovim
if exist "%LOCALAPPDATA%\nvim" rmdir /S /Q "%LOCALAPPDATA%\nvim"
robocopy "nvim" "%LOCALAPPDATA%\nvim" /E /XD .git .github

popd
exit /b
