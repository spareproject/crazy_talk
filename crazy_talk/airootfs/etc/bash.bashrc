# /etc/bash.bashrc
##########################################################################################################################################################################################
[[ $- != *i* ]] && return
if [[ $(id -u) != 0 ]];then PS1="\[\e[32m\][\u@archiso]\[\e[36m\][\w]:\[\e[m\] ";else PS1="\[\e[32m\][\u@archiso]\[\e[31m\][\w]:\[\e[m\] ";fi
PS2='> '
PS3='> '
PS4='+ '
##########################################################################################################################################################################################
alias ls='ls --color=auto --group-directories-first'
alias l='ls -lh'
alias ll='ls -alh'
alias c='clear; cat /etc/banner'
alias cl='clear;cat /etc/banner;ls -lAh'
alias ..='cd ..'
export EDITOR=vim

alias weechat='weechat -r "/plugin unload trigger;/plugin unload relay;/plugin unload script;/plugin unload fifo;/plugin unload alias;/plugin unload xfer;/plugin unload exec;/window splith 30;/buffer chanmon;/window b1"'

###############################################################################################################################################################################################################
export CAPS="CAP_CHOWN,CAP_DAC_OVERRIDE,CAP_DAC_READ_SEARCH,CAP_FOWNER,CAP_FSETID,CAP_IPC_OWNER,CAP_KILL,CAP_LEASE,CAP_LINUX_IMMUTABLE,CAP_NET_BIND_SERVICE,CAP_NET_BROADCAST,CAP_NET_RAW,CAP_SETGID,CAP_SETFCAP,CAP_SETPCAP,CAP_SETUID,CAP_SYS_ADMIN,CAP_SYS_CHROOT,CAP_SYS_NICE,CAP_SYS_PTRACE,CAP_SYS_TTY_CONFIG,CAP_SYS_RESOURCE,CAP_SYS_BOOT,CAP_AUDIT_WRITE,CAP_AUDIT_CONTROL,CAP_NET_ADMIN"
###############################################################################################################################################################################################################
function passwdgen { cat /dev/random | tr -cd 'a-zA-Z0-9' | fold -w 64 | head -n 1; }
###############################################################################################################################################################################################################
