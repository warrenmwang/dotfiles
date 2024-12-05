# Neovim Config (on Windows)

In order to learn Windows, I am actually trying to not use [WSL2](https://en.wikipedia.org/wiki/Windows_Subsystem_for_Linux).
So this configuration is for using Neovim in PowerShell.

## Setup and Installation

1. Install [scoop](https://scoop.sh/#/) package manager for Windows.
```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```
2. Install prereqs and Neovim nightly.
```
scoop install git sed ripgrep gcc make gzip fd unzip
scoop bucket add versions
scoop install versions/neovim-nightly
```
> If facing a hash check issue when installing neovim nightly, you can add a `-s` flag to skip hash checks (until the [issue](https://github.com/ScoopInstaller/Versions/issues/1717) is fixed).

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

## Misc.
Once again, config is based off of [Kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).
