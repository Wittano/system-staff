#!/usr/share/env bash
set -eo pipefail

if [ -z "$(which xsetwacom)" ]; then
    echo "Wacom driver isn't installed!"
    exit 1
fi

TABLET=$(xsetwacom list devices | awk '{print $9}')

if [ -n "$1" ]; then
    MONITOR=$1
else
    MONITOR="HEAD-0"
fi

for i in $TABLET; do
    xsetwacom --set "${i}" MapToOutput $MONITOR
done
