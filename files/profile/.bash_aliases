alias sudo='sudo '
alias ll='ls -lAhF --group-directories-first'
alias l='ls -AhF --group-directories-first'
alias dirb='find `pwd` -maxdepth 1'
alias d='date'
alias cls='clear && date'
alias t='top'
alias h='htop'
alias hds='df -h'
alias ds='du --exclude=".svn|.git" -c -h --time'
alias mc='mc -s'
alias smc='sudo mc '
alias mut='alpine'
alias x='exit'
alias git-revert="git fetch origin && git reset --hard origin/master"
alias apti='sudo aptitude'
alias re-apt='sudo aptitude install -o Dpkg::Options::=--force-confmiss '
alias aptall='sudo rm -rf /var/lib/apt/lists && sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get -y dist-upgrade && sudo apt-get -y autoremove'
alias cports='sudo lsof -i && sudo netstat -lptu'
alias hh='cat /home/user1/.bash_aliases'
alias calcdir='sudo du -ch | grep total'
alias vbox-mount='sudo mount -t vboxsf wd ~/share/'

function git-set-creds() {
    git config user.name "%1"
    git config user.email "%2"
    git config credential.helper store
}

function dirsize() {
    sudo du -ch $1 | grep total
}

alias service-list='sudo systemctl list-unit-files'

function service-status() {
    sudo systemctl status $1.service;
}
function service-enable() {
    sudo systemctl enable $1.service;
}
function service-disable() {
    sudo systemctl disable $1.service;
}
function service-start() {
    sudo service $1 start;
    #service-status $1.service;
    service-status $1;
}
function service-stop() {
    sudo service $1 stop;
    #service-status $1.service;
    service-status $1;
}

function service-restart() {
    sudo service $1 restart;
    #service-status $1.service;
    service-status $1;
}
