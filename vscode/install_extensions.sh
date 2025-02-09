#!/bin/bash

# Description:
#    Installs all the editor extensions given as a file
#    listing each extension on each line.
# Input:
#    [file path to extensions list plain text file]
# Output:
#    None

FILE=$1
if [ -z "$FILE" ]; then
    echo "Error: Input file required"
    exit 1
fi

if [ ! -f "$FILE" ]; then
    echo "Error: Input file not found: $FILE"
    exit 1
fi

while IFS= read -r extension || [ -n "$extension" ]; do
    if [ -n "$(echo "$extension" | tr -d '[:space:]')" ]; then
        echo "Installing extension: $extension"
        code --install-extension "$extension"
    fi
done < "$FILE"

echo "Finished installing extensions"
