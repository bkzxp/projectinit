#!/bin/bash

echo "shutdown vbox..."

tb stop

count=10
while true ; do
    count=$(($count - 1))
    if [ $count -gt 0 ] ; then
        clear
        echo ""
        echo " Power off in ${count} seconds ..."
        sleep 1
    else
        clear
        echo ""
        echo " Shutting down ...";
        sleep 1
        shutdown -s
        exit 0
    fi
done

