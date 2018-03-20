#!/bin/bash

############################
#
# Script to init development enviroment
# Author: Chiao <php@html.js.cn>
#
############################

initdir=/d/projectinit
giturl=http://git.we2tu.com/zhangxuepei/projectinit.git
dotrc=~/.bashrc
firstBoot=0

[ ! -d "/d" ] && {
    initdir=/c/projectinit
}

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

getRequiredBin () { # bin, return/halt
    local bin=$(which --skip-alias $1 2>/dev/null)
    [ "$bin" = "" ] && {
        echo "$1 not found."
        exit 1
    }

    [ "$2" != "" ] && {
        echo $bin
    }
}

workspace=$(simpleyml "workspace" $initdir/settings.yml)

[ ! -d "$workspace" ] && {
    while true
    do
        read -p "Please input your workspace path: (etc: /d/www) " workspace
        [ -d "$workspace" ] && {
            workspace="${workspace:1:1}:${workspace:2}"
            echo "Workspace: $workspace"
            break
        }
    done
}

getRequiredBin git
getRequiredBin vagrant

git=$(getRequiredBin git 1)
vag=$(getRequiredBin vagrant 1)

[ ! -d "$initdir" ] && {
    $git clone $giturl $initdir
    firstBoot=1
}

manageralias=$(simpleyml "manageralias" $initdir/config.yml "m")
updateyml "workspace" "$workspace" $initdir/settings.yml

[ ! -f "$workspace/domain.php" ] && {
    cp -vf $initdir/domain_tpl.php $workspace/domain.php
}

touch $dotrc
cat <<SCRIPT > ~/.tbalias
alias v='vim'
alias g='git'
alias vg='vagrant'
alias tbupdate='cd ${initdir} && git pull && tb update && . ~/.tbalias && tb updatedesktop'
alias ${manageralias}='${initdir}/sh/manager.sh'
SCRIPT
sed -i -r "/^source\s+\~\/\.tbalias/d" ~/.bashrc
echo "source ~/.tbalias" >> ~/.bashrc

[ "$firstBoot" -gt 0 ] && {
    cd $initdir
    $vag up
}
