Copy-Item -Recurse -Force -Path "$($env:APPDATA)\..\Local\nvim\" -Destination . -Exclude ".git", ".github"
