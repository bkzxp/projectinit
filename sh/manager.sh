#!/bin/bash

############################
#
# Script to init development enviroment
# Author: Chiao <php@html.js.cn>
#
############################

cmd=${1:-help}
lsbin=$(which ls)
pmdir=${0%/sh/*}
rmbin=$(which rm)
vgbin=vagrant
source $pmdir/sh/include.sh
projectRoot=$(simpleyml "workspace" $pmdir/settings.yml)
gitPrefix=$(simpleyml "gitPrefix" $pmdir/config.yml)
pmbasename=$(simpleyml "manageralias" $pmdir/config.yml)
cd $pmdir

# print repeat string
hr() {
    local c=${1:-=}
    printf "${c}%.0s" {1..44}
    echo ""
}

confirmAction() {
    read -p "Are you sure??? [yN] " iamsure
    [ "$iamsure" != 'y' ] && {
        echo "Aborted."
        exit 1
    }
}

# collect all projects path
allProjectsPath() {
    $lsbin -d ${projectRoot}/*/ 2>/dev/null
}

tryClone() {
    [ ! -d "$projectRoot/$1" ] && {
        git clone "${gitPrefix}${1}.git" $projectRoot/$1
    }
}

tryMkdirLog() {
    [ ! -d "$projectRoot/$1/log" ] && {
        mkdir $projectRoot/$1/log
    }
}

projectsGit() {
    echo -e "${RED}git $1${NC}"
    projects=${2:-$(allProjectsPath)}

    for project in $projects
    do
        project=$(basename $project)
        tryClone $project
        [ -d $projectRoot/$project/.git ] && {
            hr
            echo -e "${YELLOW}$project${NC} (${GREEN}$(git --git-dir=$projectRoot/$project/.git --work-tree=$projectRoot/$project rev-parse --abbrev-ref HEAD)${NC})"
            git --git-dir=$projectRoot/$project/.git --work-tree=$projectRoot/$project $1
        }
        tryMkdirLog $project
    done
}

# parse args for projects used by projectGit
projectsGitArgs() {
    local pos=${2:-2}
    echo $1 | cut -s -d " " -f${pos}-
}

case $cmd in
help)
    pmbasename="${GREEN}${pmbasename}${NC}"
    echo -e "${YELLOW}Try these Commands: ${NC}"
    echo ""
    echo -e "  $pmbasename {start|stop}    "
    echo ""
    echo -e "  $pmbasename {reloadphp|reloadnginx}    "
    echo ""
    echo -e "  $pmbasename pull [projects]                "
    echo ""
    echo -e "  $pmbasename checkout {branch} [projects]   "
    echo ""
    echo -e "  $pmbasename status [projects]              "
    echo ""
    echo -e "  $pmbasename clean [projects]               "
    echo ""
    echo -e "  $pmbasename gitconfig"
    echo ""
    echo -e "  $pmbasename reload"
    echo ""
    echo -e "  $pmbasename ssh"
    echo ""
    echo -e "  ${GREEN}tbupdate${NC} "
    ;;
gitconfig)
    git config --global alias.co checkout
    git config --global alias.br branch
    git config --global alias.st status
    git config --global alias.ci commit
    git config --global alias.cl "clone --recursive"
    git config --global alias.me "merge --no-ff"
    git config --global alias.last "log -1 HEAD"
    git config --global alias.unstage "reset HEAD --"
    git config --global alias.hist "log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short"
    git config --global alias.stoptrack "update-index --assume-unchanged"
    git config --global core.autocrlf true
    git config --global credential.helper wincred
    ;;
update)
    cat <<SCRIPT > ~/.tbalias
alias v='vim'
alias g='git'
alias vg='vagrant'
alias tbupdate='cd ${pmdir} && git pull && tb update && . ~/.tbalias && tb updatedesktop'
alias ${pmbasename}='${pmdir}/sh/manager.sh'
alias gcamp='git commit -am ... && git push'
SCRIPT
    sed -i -r "/^source\s+\~\/\.tbalias/d" ~/.bashrc
    echo "source ~/.tbalias" >> ~/.bashrc
    ;;
pull)
    projectsGit "pull" "$(projectsGitArgs "$*")"
    ;;
co|checkout)
    branch=$(echo $*|cut -s -d" " -f2)
    projectsGit "checkout -q $branch" "$(projectsGitArgs "$*" 3)"
    ;;
g|git)
    projectsGit "$2" "$3"
    ;;
st|status)
    projectsGit "status -s" "$(projectsGitArgs "$*")"
    ;;
clean)
    projectsGit "clean -di -e log" "$(projectsGitArgs "$*")"
    ;;
log)
    logfile=$pmdir/logs/php_errors.log
    [ "$2" = "clean" ] && rm -rf $logfile
    [ ! -f $logfile ] && touch $logfile
    tail -f $logfile
    ;;
desktop)
    cp -vf $pmdir/start.sh ~/Desktop/start.sh
    cp -vf $pmdir/886.sh ~/Desktop/886.sh
    ;;
updatedesktop)
    [ -f ~/Desktop/start.sh ] && {
        cp -f $pmdir/start.sh ~/Desktop/start.sh
        cp -f $pmdir/886.sh ~/Desktop/886.sh
    }
    ;;
ssh)
    $vgbin ssh
    ;;
start)
    $vgbin up --provision-with reloadnginx
    ;;
stop)
    $vgbin suspend
    ;;
reload)
    $vgbin reload --provision-with reloadnginx
    ;;
reloadphp)
    echo -e "Reloading file: ${GREEN} $pmdir/php.ini/php.ini ${NC}"
    $vgbin provision --provision-with reloadphp
    ;;
reloadnginx)
    echo -e "Reloading nginx vhosts in ${GREEN}$pmdir/conf ${NC}: ${YELLOW}"
    ls -1 $pmdir/conf
    echo -e "${NC}"
    $vgbin provision --provision-with reloadnginx
    ;;
reset)
    confirmAction
    $vgbin destroy -f
    $rmbin -rf .vagrant
    $vgbin global-status --prune
    git --git-dir=$pmdir/.git --work-tree=$pmdir pull -f
    $vgbin up
    ;;
*)
    $0 help
    ;;
esac
