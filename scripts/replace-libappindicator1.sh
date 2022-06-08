#!/bin/bash

set -oe

OUTPUT_DIR="/tmp"
PROGRAM_NAME=$(basename $1 | cut -f 1 -d '-')
TEMP_DIR="$OUTPUT_DIR/$PROGRAM_NAME"
DEBIAN_DIR="$TEMP_DIR/DEBIAN"

_log() {
    local now=$(date +"%D %T")

    echo -e "\n[$now]: $1 \n"
}

_clean() {
    _log "Clean outputs"

    rm -r $TEMP_DIR
    rm "$OUTPUT_DIR/$PROGRAM_NAME.deb"
}

_exit_script() {
    _clean
    exit 1
}

_main() {
    _log "Extract $1 deb archive"
    dpkg-deb -x $1 $TEMP_DIR
    dpkg-deb -e $1 $DEBIAN_DIR

    _log "Fix libappindicator1 library"
    sed -i "s/libappindicator1/libayatana-appindicator1/g" "$DEBIAN_DIR/control"

    _log "Create new deb archive for: $PROGRAM_NAME"
    dpkg -b $TEMP_DIR

    _log "Install new program"
    sudo apt install $1
}

case $1 in
*.deb)
_main $1 || _exit_script
;;
*)
echo "Invalid file. Acceptable files are .deb archives"
exit 1
esac