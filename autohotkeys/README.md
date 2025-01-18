# Autohotkeys

## Getting Started

The quickest way to get up and running is to run in PowerShell:
```shell
scoop install extras/autohotkey
.\setup_autohotkeys.ps1
```
This will install autohotkey for your user, create the shortcuts to the ahk scripts in this directory in the startup applications folder, and then run the scripts to allow using them immediately.

Since AutoHotKey v2 came out at the end of 2022, which is now about 2 years ago at time of writing, we
should try to keep our autohotkey scripts to be the newer version. Alas, always moving into the future.
Luckily, however, we can run scripts that are version 1 alongside the version 2 ones. By convention,
the `.ahk` extension is for version 1 scripts and `.ah2` is for version 2 scripts.

## Notes

Autohotkeys can be installed from one of the following sources:
- [website](https://www.autohotkey.com/)
- [github](https://github.com/AutoHotkey/AutoHotkey)
- [scoop](https://scoop.sh): `scoop install extras/autohotkey`

To create an autohotkey write the script into an `.ahk` file and then run it with AutoHotKey.
To enable an autohotkey to be enabled at startup time:
1. `Win+R`
2. Enter `shell:startup`
3. Create a shortcut to the actual autohotkey script `.ahk` file.

## Dependencies
For virtual desktop switching and other operations, I rely on `VD.ah2` which comes from this [repo](https://github.com/FuPeiJiang/VD.ahk/tree/v2_port). Thanks to them.