#!/usr/bin/env bash
rsync -av --delete \
    --exclude 'import.sh' \
    --exclude 'export.sh' \
    --exclude '.git' \
    ./ ~/.config/nvim/
