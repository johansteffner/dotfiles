export CLICOLOR=1
export LSCOLORS=dxfxcxdxbxegedabagacad
export LANG=en_US.UTF-8
export LC_CTYPE="en_US.UTF-8"
export EDITOR='vim'
export NVM_DIR="/Users/johan/.nvm"
export PS1="\u:\W\$ "

if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

if [ -d ~/bin ] ; then
    export PATH="~/bin:$PATH"
fi

alias 'ls'='ls -hpAG'
alias 'll'='ls -l'
alias 'la'='ll'
alias 'ack'='ack --color-filename=green --color-match=yellow --ignore-dir=log --ignore-dir=tmp'
