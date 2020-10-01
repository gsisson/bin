#!/usr/bin/env bash

# - This script is kept in ~/usr/bin0/
# - It is used in conjunction with the the command completion function
#   defined in the file of the same name in the completion/ dir below the bin/ dir

green="\033[0;92m"
cyan="\033[0;96m"
off="\033[0m"

if [ "$#" -gt 1 ]; then
  set -- # force usage message if more than one argument passed
fi

_usage() {
  echo -e "usage: `basename $0` DIR_OR_FILE"
  echo -e "  where DIR_OR_FILE is ${cyan}an existing directory${off}"
  echo -e "                    or ${cyan}an existing or new file${off}"
  echo -e "  or one of these shortcut names for special dirs and files:"
  $0 options
  exit 1
}

_edit() {
  # _edit [-d] DIR_OR_FILE
  #   -d            if specified, and if DIR_OR_FILE is not in fact a directory [i.e. it
  #                 is a file or does not exist], then an error message will be printed
  #   DIR_OR_FILE   the directory or files to be edited
  #
  local type
  if [ "$1" = '-d' ]; then
    type="$1"
    shift
  fi
  local TARGET="$@"
  if [ "$type" != '-d' -a -d "$TARGET" ]; then
    type='-d'
  fi
  local DEFAULT_EDITOR=code
  EDITOR="${EDITOR:=$DEFAULT_EDITOR}"
  if [ "$type" = '-d' -a ! -d "${TARGET}" ]; then
    echo "ERROR: '$TARGET' directory does not exist!" 1>&2
    exit 1
  fi
  if ! which "$EDITOR" > /dev/null 2>&1; then
    echo 'cannot find "'$EDITOR'" editor! ($EDITOR = "'$ED'")' 1>&2
    exit 1
  fi
  if [[ "$EDITOR" =~ ^${HOME} ]]; then
    echo -e ${green}exec "~${EDITOR#$HOME}" "$@"${off}
  else
    echo -e ${green}exec "$EDITOR" "$@"${off}
  fi
  eval exec "$EDITOR" "$@"
}

_options() {
  # Generates and returns a list of 'valid options' for the passed 'filter' argument.
  # Scans this source file looking for the lines with the 'filter' word, and extracts
  # from those lines a single word.  Usually these are words found in the options of
  # a 'case' statement.  This allows easily changing the valid options, by simply
  # addig a new case statement.  case statement lines with "#ignore" on them will be
  # reoved from the result.
  filter="${1}"
  cat $0 | \grep -v  '#ignore'| \grep "[a-z0-9]).*${filter}" | sed -e 's:).*::' -e 's:^:  :' | column
  exit
}

case "$1" in
  aws-credentials)          _edit -f ~/.aws/credentials;;
  iac-terraform-live-dev)   _edit -d ~/src/iac_terraform_live/DEV;;
  iac-terraform-live-stg)   _edit -d ~/src/iac_terraform_live/STAGE;;
  iac-terraform-live-prod)  _edit -d ~/src/iac_terraform_live/PROD;;
  iac-terraform-modules)    _edit -d ~/src/iac_terraform_modules;;
  jenkins)                  _edit -d ~/src/$1;;
  # ----------------------------------------------------------------------
  *-options) _options $1;; #ignore
  options)   _options '';; #ignore
  '')        _usage;;
  *)         _edit "$@";;
esac  
