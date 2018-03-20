#!/bin/sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

simpleyml () { # key,file,default
    [ -f "$2" ] && {
        local value=$(sed -ne "/^${1}:/p" $2 2>/dev/null|cut -s -d" " -f2-)
        if [ "$value" != "" ]; then
            echo $value
        else
            echo $3
        fi
    }
}

updateyml () { # key,value,file
    touch $3
    sed -i -r "/^${1}:/d" $3
    echo "${1}: ${2}" >> $3
}
