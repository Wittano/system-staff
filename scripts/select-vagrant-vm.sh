#!/bin/bash
set -eo pipefail

_error_msg() {
    echo $1
    exit -1
}

if [ -z $1 ] || [ -z $2 ]; then
    _error_msg 'Invalid arguments: vm <vm_name> <vagrant_option>' 
fi 

if [ -z $(command -v vagrant) ]; then
    _error_msg 'Vagrant not found!'
fi

vms_dir=$HOME/projects/config/system/vms
vms=$(ls $vms_dir)

for dir in $vms; do
    if [ "$dir" == "$1" ]; then
        cd $vms_dir/$dir

        vagrant $2
    fi
done