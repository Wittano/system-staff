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

if [ "$1" == "all" ]; then
    for dir in $vms; do
        echo "$dir - virutal machine"
        cd $vms_dir/$dir

        vagrant $2
    done

    exit 0
fi

for dir in $vms; do
    if [ "$dir" == "$1" ]; then
        vm_dir=$vms_dir/$dir

        cd $vm_dir

        mkdir -p $vm_dir/data

        if [ $2 == 'rebuild' ]; then
            vagrant destroy
            vagrant up
        else
            vagrant $2
        fi
    fi
done
