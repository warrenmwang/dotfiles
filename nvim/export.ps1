# ik, this is a pile of ****, im sorry.
cd ..
rm -Recurse -Force ~\AppData\Local\nvim
Copy-Item -Recurse -Force -Path ".\nvim" -Destination "~\AppData\Local\nvim" -Exclude ".git", ".github"
cd nvim