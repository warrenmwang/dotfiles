@echo off

REM Run from this script's directory so relative paths work from any shell.
pushd "%~dp0"

REM Git
copy /Y "%USERPROFILE%\.gitconfig" ".gitconfig"

REM VS Code
copy /Y "%APPDATA%\Code\User\keybindings.json" "vscode\keybindings.json"
copy /Y "%APPDATA%\Code\User\settings.json" "vscode\settings.json"

REM Neovim
robocopy "%LOCALAPPDATA%\nvim" "nvim" /E /XD .git .github

popd
exit /b
