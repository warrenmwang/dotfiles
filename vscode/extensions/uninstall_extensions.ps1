# Description:
#    Uninstalls all the currently installed extensions.
#    NOTE: This doesn't remove any config files associated with removed extensions.
#    I don't remove them here because we might install them back...

$extensions = code --list-extensions
foreach ($extension in $extensions) {
    if ($extension.Trim()) {  # Skip empty lines
        Write-Host "Uninstalling extension: $extension"
        code --uninstall-extension $extension
    }
}

Write-Host "Finished uninstalling extensions"
