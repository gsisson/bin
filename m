#!/usr/bin/env bash

# - This script is kept in ~/usr/bin/
# - It is used in conjunction with the the command completion function
#   defined in the file of the same name in the functions/completion/ dir below the bin/ dir

_color-prompt-ex() {
  # print out a command to set a colored PS1 prompt for Linux systems.
  # ( hardcoded to create this kind of prompt: [ec2-user@YOUR_STRING /current/dir] )
  # pass two colors and their names as args, plus a string to be embedded in the prompt
  #
  # ex: _color-prompt-ex "1;91m" 'red' "7;103;90m" 'yellow on grey' "Jenkins"
  #
  COLOR_MAIN="$1"
  COLOR_MAIN_NAME="$2"
  COLOR_HOST="$3"
  COLOR_HOST_NAME="$4"
  PROMPT="$5"
  if [ $COLOR_MAIN_NAME != white ]; then
    echo -e "\033[${COLOR_MAIN}[ec2-user@${PROMPT} /var/log]\033[00m"
    echo -e "\033[${COLOR_MAIN} "  echo PS1=\"\''\[\\033['${COLOR_MAIN}'\][\u@'${PROMPT}' \w]\$ \[\\033[00m\]'\'\" \>\> .bashrc      "\033[00m"
  fi
  echo -e "\033[${COLOR_MAIN}[ec2-user@\033[${COLOR_HOST}${PROMPT}\033[00m\033[${COLOR_MAIN}/var/log]\033[00m"
  echo -e "\033[${COLOR_MAIN} "  echo PS1=\"\''\[\\033['${COLOR_MAIN}'\][\u@\[\\033[00m\]\[\\033['${COLOR_HOST}'\]'${PROMPT}'\[\\033[00m\]\[\\033['${COLOR_MAIN}'\]\w]\$ \[\\033[00m\]'\'\" \>\> .bashrc      "\033[00m"
}

_show-color-prompt-exs() {
  prompt="$@"
  echo
  echo "# Example commands to change the PS1 prompt on the target server:"
  echo "# copy and paste into shell to change the prompt:"
  #                            color      secondary    secondary color
  #                color       name       color        name
  _color-prompt-ex "1;91m"      'red'      "7;103;90m"  'yellow on grey'  "$prompt"
  _color-prompt-ex "0;93m"      'yellow'   "7;103;90m"  'yellow on grey'  "$prompt"
  _color-prompt-ex "1;96m"      'cyan'     "7;106;90m"  'cyan on grey"'   "$prompt"
  _color-prompt-ex "1;96m"      'cyan'     "7;102;90m"  'green on grey"'  "$prompt"
  _color-prompt-ex "38;05;141m" 'purple'   "7;106;90m"  'cyan on grey"'   "$prompt"
  _color-prompt-ex "38;05;214m" 'orange'   "7;103;90m"  'yellow on grey'  "$prompt"
  _color-prompt-ex "0;92m"      'green'    "7;102;90m"  'green on grey"'  "$prompt"
  _color-prompt-ex "0;97m"      'white'    "7;107;90m"  'white on grey"'  "$prompt"
  _color-prompt-ex "0;97m"      'white'    "7;108;90m"  'black on grey"'  "$prompt"
  _color-prompt-ex "0;97m"      'white'    "7;102;40m"  'black on white"' "$prompt"
  echo
}

_show-all-aws-accounts() {
  grep 'aws-accounts-options' $0 | grep -v all | sed -e 's: *\(.*\)) *echo "\(.*\)".*:\1	\2:'
}

_options() {
  filter="${1}"
  cat $0 | grep -v 'options)'| grep "[a-z0-9]).*${filter}" | sed -e 's:).*::' -e 's:^:  :' | column
  exit
}

case "$1" in
  # aws-accounts ---------------------------------------------------------
  aws-accounts-usage)
    echo -e "usage: `basename $0` ${1%-usage} AWS_ACCOUNT_NICKNAME"
    echo -e "\nPrints out the account number for the named account.\n"
    echo -e "   ex: `basename $0` ${1%-usage} myAwsAccountAlias"
    echo -e "       (hit TAB key for command completion)"
    exit 1;;
  aws-accounts) # top-level
    case $2 in
      all)     _show-all-aws-accounts;; # aws-accounts-options
      one)     echo "000111001100"   ;; # aws-accounts-options
      two)     echo "004440044000"   ;; # aws-accounts-options
      *) $0 ${1}-usage;;
    esac;;
  # color-prompt-ex ------------------------------------------------------
  color-prompt-ex-usage)
    echo -e "usage: `basename $0` ${1%-usage} STRING_FOR_PROMPT"
    echo -e "\nPrints out colored PS1 prompt examples\n"
    echo -e "   ex: `basename $0` ${1%-usage} service-stg"
    echo -e "   ex: `basename $0` ${1%-usage} service-apps"
    echo -e "       (hit TAB key for command completion)"
    exit 1;;
  color-prompt-ex) # top-level
    if [ -z "$2" ]; then $0 ${1}-usage ; exit 1; fi
    shift; _show-color-prompt-exs "$@"
    ;;
  # sane home ------------------------------------------------------------
  sane-home-usage)
    echo -e "usage: `basename $0` ${1%-usage} [SERVER_NAME_FOR_PS1]"
    echo -e "\nPrints out env vars to create a sanely colored experience\n"
    exit 1;;
  sane-home) # top-level
    echo export GREP_COLORS='"ms=01;30;46:mc=01;31:sl=:cx=:fn=32:ln=32:bn=32:se=36"'
    echo export LS_COLORS='"no=00:fi=01;97;40:di=01;96;40:ln=01;07;97;40:pi=30;43:so=01;95:do=95:bd=01;93;43:cd=01;93;43:or=05;01;91;40:mi=05;30;101:su=07;01;31;107:sg=07;01;35;107:tw=30;103:ow=07;91;107:st=01;97;43:ex=01;92;40:*.set_guid=07;01;35;107:*.set_uid=07;01;31;107:*.sticky_other_writable=30;103:*.other_writable=07;91;107:*.sticky=01;97;43:*.socket=01;95:*.named_pipe=30;43:*.block_device=01;93;43::*.char_device=01;93;43"'
    if [ -z "$2" ]; then
      echo '  echo PS1="'\''\\'\['\\033[38;05;214m\\][\\u@\\h \w]\\$ \\[\\033[00m\\]'\'\" \>\> .bashrc
    else
      echo '  echo PS1="'\''\\'\['\\033[38;05;214m\\][\\u@'$2' \w]\\$ \\[\\033[00m\\]'\'\" \>\> .bashrc
    fi
    echo "cat '$(dirname $0)/../lib/profile/vimrc' | pbcopy"
    cat "$(dirname $0)/../lib/profile/vimrc" | pbcopy
    ;;
  # ----------------------------------------------------------------------
  *-options) _options "# $1";;
  options) _options '# top-level';;
  *) echo "usage: `basename $0` OPTION"
     echo "  where OPTION is one of:"
     $0 options;exit 1;;
esac
