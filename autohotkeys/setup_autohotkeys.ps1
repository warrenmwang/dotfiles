# create startup shortcuts to scripts in cwd, starts them with the autohotkey binary
# expected to be in path

$autohotkeyPath = (Get-Command "AutoHotkey.exe").Source

$ahkFiles = Get-ChildItem -Path $PSScriptRoot -Filter "*.ah2"
$startupFolder = [System.Environment]::GetFolderPath('Startup')

foreach ($ahkFile in $ahkFiles) {
    $shortcutPath = Join-Path $startupFolder "$($ahkFile.BaseName).lnk"
    $WScriptShell = New-Object -ComObject WScript.Shell
    $shortcut = $WScriptShell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $autohotkeyPath
    $shortcut.Arguments = "`"$($ahkFile.FullName)`""
    $shortcut.WorkingDirectory = $ahkFile.DirectoryName
    $shortcut.Save()
    Write-Host "Created startup shortcut for $($ahkFile.Name)"

    Start-Process $autohotkeyPath -ArgumentList "`"$($ahkFile.FullName)`""
    Write-Host "Launched $($ahkFile.Name)"
}
