#!/usr/bin/env bash

# if [ "$(type -t _fn)" != 'function' ]; then

if [ "$_" = "$0" ];then
  # running as a script
  echo 'do work'
  exit
fi

# this file is being 'sourced',
# so setup command completion

if [ -n $BASH_SOURCE ]; then
  echo '== running zsh? ==' 1>&2
else
  echo '== running bash ==' 1>&2
  echo "+ complete -F _fn $(basename $BASH_SOURCE)"
          complete -F _fn $(basename $BASH_SOURCE)
fi

_fn()
{
  if [ -n $BASH_SOURCE ]; then
    echo '== running zsh? ==' 1>&2
  else
    echo '== running bash ==' 1>&2
    local curr_arg;
    # echo $COMP_WORDS > ~/1
    # echo $COMP_CWORD >> ~/1
    curr_arg=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -W '-i --incoming -o --outgoing -m --missed' -- $curr_arg ) );
  fi
}
