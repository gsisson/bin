#!/usr/bin/env bash
. ~/.bashrc

# go into a temp directory, and create some various file types,
# then show them with 'ls' so the colors can be seen

case "$(uname)" in
  *CYGWIN*) options="-p /cygdrive/c/tmp/";;
  *Darwin*) ;;
esac

TMPDIR=`mktemp -d $options`

cd $TMPDIR
mkdir directory
touch executable
chmod +x executable
touch file
touch file.missing
touch file.set_uid
touch file.set_guid
touch file.sticky_other_writable
touch file.other_writable
touch file.sticky
touch file.socket
touch file.named_pipe
touch file.block_device
touch file.char_device


case "$(uname)" in
  *CYGWIN*) # need to fix ln() alias, so it calls mklink.bat
            # with relative args, if passed relative args,
            # then calling mklink.bat directly would not be necessary
            mklink.bat /d   valid file
            mklink.bat /d invalid file.bad
	    ;;
  *Darwin*) ln -s file       valid >/dev/null 2>&1
            ln -s file.bad invalid >/dev/null 2>&1
	    ;;
esac

rm file.missing

alias ls
ls -d * /dev/stderr
echo

alias ll
ll -d * /dev/stderr
echo

rm -rf $TMPDIR 
