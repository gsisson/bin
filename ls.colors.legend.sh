#!/usr/bin/env bash
. ~/.bashrc

# go into a temp directory, and create some various file types,
# then show them with 'ls' so the colors can be seen
TMPDIR=`mktemp -d`
cd $TMPDIR
mkdir directory
touch executable
chmod +x executable
touch file
touch file.set_uid
touch file.set_guid
touch file.sticky_other_writable
touch file.other_writable
touch file.sticky
touch file.socket
touch file.named_pipe
touch file.block_device
touch file.char_device
ln -s file    valid >/dev/null 2>&1
ln -s c:/BOGUS invalid >/dev/null 2>&1

alias ls
ls -d * /dev/stderr
echo

alias ll
ll -d * /dev/stderr
echo

rm -rf $TMPDIR 
