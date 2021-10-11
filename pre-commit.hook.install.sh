#!/usr/bin/env bash

top=$(git rev-parse --show-toplevel)

src=~/.git/hooks/pre-commit
src_disabled=~/.git/hooks/pre-commit_UNINSTALLED

if [ ! -f $src -a ! -f $src_disabled ]; then
  echo "ERROR: missing both $src and $src_disabled!"
  exit 1
fi

case "$(basename $0)" in
  pre-commit.hook.install.sh)
    case "$top" in
      "$HOME")
        if [ -f "$src_disabled" ]; then
          rm -f "$src"
          cmd="mv $src_disabled $src"
          echo + $cmd ;eval $cmd
        else
          echo "INFO: already installed"
        fi
        ;;
      *)
        if [ -f $top/.git/hooks/pre-commit ]; then
          echo "INFO: already installed"
          exit
        fi
        if [ ! -f "$src" ]; then
          src="$src_disabled"
        fi
        cmd="cp $src $top/.git/hooks/pre-commit"
        echo + $cmd ;eval   $cmd
        cmd="cp ~/.pre-commit-config.yaml $top/"
        echo + $cmd ;eval   $cmd
        ;;
    esac
    ;;
  pre-commit.hook.uninstall.sh)
    case "$top" in
      "$HOME")
        if [ -f "$src" ]; then
          rm -f "$src_disabled"
          cmd="mv $src $src_disabled"
          echo + $cmd ;eval $cmd
        else
          echo "INFO: already un-installed"
        fi
        ;;
      *)
        if [ ! -f $top/.git/hooks/pre-commit ]; then
          echo "INFO: already un-installed"
          exit
        fi
        cmd="rm $top/.git/hooks/pre-commit"
        echo + $cmd ;eval   $cmd
        ;;
    esac
    ;;
esac
