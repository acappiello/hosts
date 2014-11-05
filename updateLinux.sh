#!/bin/bash

if [ $EUID -ne 0 ]
then
    echo "*********************************************"
    echo "Not running as root. Calling sudo on self."
    echo "*********************************************"
    sudo $0 $@
else
    echo "Backing up old hosts file to hosts_old."
    mv /etc/hosts /etc/hosts_old
    echo "Copying new hosts file."
    cp hosts /etc/hosts
    echo "Flushing DNS."
    /etc/init.d/dns-clean
fi

exit 0
