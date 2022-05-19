#!/bin/bash

if [ -z "$(command -v rsync)" ]; then
    echo "rsync not found"
    exit 1
fi

CURRENT_DIR=$(dirname "$0")

sudo rsync -aAXv --delete --exclude-from="${CURRENT_DIR}/raspberry-exclude.txt" -e "ssh -i /home/wittano/.ssh/id_rsa" / raspberry@192.168.1.5:/mnt/backup/raspberry
