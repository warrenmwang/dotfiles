#!/bin/bash

# Description:
#    Uninstalls all the currently installed extensions.
#    NOTE: This doesn't remove any config files associated with removed extensions.
#    I don't remove them here because we might install them back...

extensions=$(code --list-extensions)
while IFS= read -r extension; do
    if [ -n "$(echo "$extension" | tr -d '[:space:]')" ]; then  # Skip empty lines
        echo "Uninstalling extension: $extension"
        code --uninstall-extension "$extension"
    fi
done <<< "$extensions"

echo "Finished uninstalling extensions"
