#!/bin/bash

#shortcuts
alias diff="colordiff" # colorized diffs
alias n="nano" # nano text editor
alias m="mousepad" # mousepad text editor
alias o="xdg-open" # open file with associated program
alias encrypt="gpg -c" # encrypt file with GPG
alias decrypt="gpg -d" # decrypt GPG encrypted file
alias chx='chmod a+x' # set execute permission
alias clipboard='xclip -selection c; notify-send --icon=gtk-paste "Copied to clipboard." 2>/dev/null' # send stdin to clipboard
function f { find ./ -name "*$1*"; } # find files in the currect directory
function psg { ps -fp $(pgrep -f "$@"); } # find running process matching a name

#ls and grep aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls -F --color=auto'
    alias ll='ls -lhF --color=auto'
    alias ls='ls -F --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

#load autojump
if [ -f /usr/share/autojump/autojump.sh ]; then . /usr/share/autojump/autojump.sh; fi

#use a colored prompt
force_color_prompt=yes

# Prevent ">" from overwriting existing files, use ">|" instead
set -o noclobber

# Append commands to history file instead of overwriting it
shopt -s histappend

# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL=erasedups:ignoredups:ignorespace

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
#HISTSIZE=1000
#HISTFILESIZE=2000

# Aliases for going up multiple directories
#alias .1='cd ../'
#alias .2='cd ../../'
#alias .3='cd ../../../'
#alias .4='cd ../../../../'
#alias .5='cd ../../../../../'

# Do not delete files with rm, put them to trash
#alias rm="echo 'DO NOT USE RM. Use trash-put, or frm to force rm. Putting files to trash.'; trash-put $*"
# Add an alias for rm
#alias frm="\rm"

# Close terminal after 10 minutes of inactivity
#export TMOUT=600

# Create directories and their parents
#alias mkdir='mkdir -pv'

# Use windows-style (cycling) Tab-completion
#bind '"\t":menu-complete'

# Automatically correct typos in directories names
#shopt -s cdspell

# Check recursively for subdirectories when using cd
#export CDPATH=.:~

# Automatically cd to a directory when you enter it's name on its own
#shopt -s autocd

# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS
#shopt -s checkwinsize

# Ignore case on auto-completion
#bind "set completion-ignore-case on"; fi
#bind "set show-all-if-ambiguous On"; fi

# show a ✔ or ✕ symbol before the prompt depending on return code of previous command
# $(__exit_code_block) must be added to your $PS1
#function __exit_code_block() {
#	if [[ "$?" == 0 ]]; then echo -e "✔ ";
#	else echo -e "✕ "; fi
#}

####### Colored manpages ##########
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[36;7;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

#git prompt configuration
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w $(__git_ps1 "(%s)")\[\033[00m\]\$ '
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM="auto"
