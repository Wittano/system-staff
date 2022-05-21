#!/bin/bash

RASPBERRY_IP="192.168.1.8"

if ! ping -c 1 -w 1 $RASPBERRY_IP >/dev/null; then
    ssh -i "$HOME/.ssh/id_rsa wittano@$RASPBERRY_IP" "sudo poweroff"
fi
