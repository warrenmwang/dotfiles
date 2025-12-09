#!/usr/bin/env bash

set -e

if [ $# -ne 2 ]; then
    echo "Usage: $0 [hostname] [action]"
    echo "Example: $0 nixhalla build"
    echo "Example: $0 nixhalla switch"
    exit 1
fi

HOSTNAME=$1
ACTION=$2

if [ "$ACTION" = "switch" ]; then
    BACKUP_FILE="/home/wang/.gtkrc-2.0.hm-backup"
    if [ -f "$BACKUP_FILE" ]; then
        echo "Removing previous backup: $BACKUP_FILE"
        rm "$BACKUP_FILE"
    fi
fi

nixos-rebuild $ACTION --flake .#$HOSTNAME --build-host wang@rock --sudo
