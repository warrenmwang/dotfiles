Copy-Item -Recurse -Force -Path "./*" -Destination "$($env:APPDATA)\..\Local\nvim\" -Exclude ".git", ".github"
