# Description:
#    Creates a list of the currently installed extensions for code/cursor
#    and saves it into a plain text file.
# Input:
#    None
# Output:
#    A text file `extensions.txt` with the list of extensions currently installed
#    in the same directory as this script.

$extensions = code --list-extensions
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$outputPath = Join-Path $scriptPath "extensions.txt"
$extensions | Out-File -FilePath $outputPath -Encoding UTF8

Write-Host "Extensions exported to: $outputPath"