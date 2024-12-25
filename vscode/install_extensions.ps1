# Description:
#    Installs all the editor extensions given as a file
#    listing each extension on each line.
# Input:
#    [file path to extensions list plain text file]
# Output:
#    None

param(
    [Parameter(Mandatory=$true)]
    [string]$InputFile
)

if (-not (Test-Path $InputFile)) {
    Write-Error "Input file not found: $InputFile"
    exit 1
}

$extensions = Get-Content $InputFile
foreach ($extension in $extensions) {
    if ($extension.Trim()) {  # Skip empty lines
        Write-Host "Installing extension: $extension"
        code --install-extension $extension
    }
}

Write-Host "Finished installing extensions"
