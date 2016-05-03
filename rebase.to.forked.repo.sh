#!/usr/bin/env bash

  example_account=robbyrussell
     example_repo=robbyrussell/oh-my-zsh
example_shorthand=robby

usage() {
  echo "$(basename $0) <shorthand> [--repo <account/repo>]"
  echo "  ex: $(basename $0) $example_shorthand --repo ${example_repo}"
  echo "      $(basename $0) $example_shorthand"
  exit 1
}

if [ $# = 3 -a "$2" = '--repo' ]; then
  shorthand=$1
  shift
  shift
  repo=$1
  shift
fi

if [ $# = 1 ]; then
  shorthand=$1
  shift
fi

if [ $# != 0 ]; then
  usage
fi

if [ -z "$repo" ]; then
  echo
  echo "Looking for a remote called '$shorthand'..."
  echo "+ git remote show | grep '$shorthand' >/dev/null 2>&1"
  git remote show | grep "$shorthand" >/dev/null 2>&1
  if [ $? != 0 ]; then
    echo '  ...not found'
    echo
    echo 'You must run again and use the --repo option!'
    echo
    usage
  fi
fi

if [ -n "$repo" ]; then
  echo
  echo '  adding the remote...'
  echo + git remote add "$shorthand" "git@github.com:$repo"
         git remote add "$shorthand" "git@github.com:$repo"
  echo
fi

if [ -n "$(git ls-files -m)" ]; then
  echo
  echo 'ERROR: You have unstaged changes. Please commit or stash them.'
  echo
  exit 1
fi

if [ -n "$(git diff --cached)" ]; then
  echo
  echo 'ERROR: You have uncommitted changes. Please commit or stash them.'
  echo
  exit 1
fi

echo
echo 'Fetching all the branches of that remote into remote-tracking branches...'
echo + git fetch "$shorthand"
       git fetch "$shorthand"

echo
echo "Making sure that you're on your master branch..."
echo + git checkout master
       git checkout master

echo
echo "Rewriting your master branch so that any commits of yours that"
echo "are not already in ${example_shorthand}/master are replayed on top of it..."
echo + git rebase "$shorthand"/master
       git rebase "$shorthand"/master
