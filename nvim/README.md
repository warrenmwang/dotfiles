# Neovim Config

note: last verified to work with nvim v0.11.1

## Linux

ubuntu
```
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install make gcc ripgrep unzip git xclip neovim
```

## Windows

In order to learn Windows, I am actually trying to not use [WSL2](https://en.wikipedia.org/wiki/Windows_Subsystem_for_Linux).
So there are some switches in the code for allowing Neovim to work within PowerShell.

## Setup and Installation

1. Install [scoop](https://scoop.sh/#/) package manager for Windows.
```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```
2. Install prereqs and Neovim.
```
scoop install git sed ripgrep gcc make gzip fd unzip
scoop install main/neovim
```
3. Export dotfiles
- Windows `.\export.ps1`
- Linux `./export.sh`

4. *(absolutely mandatory!!)* Install Nerd Font.
If you're setting this up, you're likely to be setting up fonts for the first time too.
You can install Cousine Nerd Font Mono (current fav) via scoop too!
```
scoop bucket add nerd-fonts
scoop install nerd-fonts/Cousine-NF-Mono
```

## Additional Steps for some plugins 
1. If going to use Avante.nvim for direct AI assistance, don't forget to set your Anthropic API Key in the PowerShell Profile script:
    - `nvim $PROFILE`
    - Then set `$env:ANTHROPIC_API_KEY='the-api-key'` in the script.
2. If going to use MarkdownPreview plugin, if you're using `npm` and `node` from scoop installation, it seems like you need to install
the dependencies manually for this plugin? Try using the plugin, and if it doesn't work with an error like `"Cannot find module 'tslib'"`, then
you'll likely need to do something like this
```
cd ~\AppData\Local\nvim-data\lazy\markdown-preview.nvim\app
npm install
```

## Starting Code
This config is based off of [Kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).
