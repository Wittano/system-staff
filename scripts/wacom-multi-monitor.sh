#!/usr/share/env bash
set -eo pipefail

if [ -z "$(which xsetwacom)" ]; then
    echo "Wacom driver isn't installed!"
    exit 1
fi

TABLET=$(xsetwacom list devices | awk '{print $9}')

for i in $TABLET; do
    xsetwacom --set "${i}" MapToOutput HEAD-0
done
