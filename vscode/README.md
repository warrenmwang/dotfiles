# VS Code Setup

Install the nerd font [Cousine Nerd Font Mono](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/Cousine.zip).

## Copying the config files to the default location

Linux
```
cp keybindings.json ~/.config/Code/User/keybindings.json
cp settings.json ~/.config/Code/User/settings.json
```

Windows (PowerShell)
```
cp keybindings.json $env:APPDATA\Code\User\keybindings.json
cp settings.json $env:APPDATA\Code\User\settings.json
```

For extensions, install on an as needed basis. The `extensions.txt`
list is just provided as an arbitrary snapshot of my VS Code extensions.

# For VSCode Forks

e.g. Cursor - Windows (PowerShell)
```
cp keybindings.json $env:APPDATA\Cursor\User\keybindings.json
cp settings.json $env:APPDATA\Cursor\User\settings.json
```

