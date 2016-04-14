#!/usr/bin/env bash

echo 'Fix from Apple'
echo 'http://support.apple.com/kb/DL1767 – OS X Lion'
echo 'http://support.apple.com/kb/DL1768 – OS X Mountain Lion'
echo 'http://support.apple.com/kb/DL1769 – OS X Mavericks'

exit 0

set -e # abort on any error

if sudo ls >/dev/null 2>&1 ; then
  echo 'failed to run sudo command!'
  echo 'please run a sudo command first, so sudo is enabled, then start this script'
  exit 1
fi

exit

for shell in bash sh ; do
  if ! $shell --version | grep '3.2.51(1)' >/dev/null 2>&1 ;then
    echo 'patch not needed'
    exit 0
  fi
done

if [ -f /bin/bash.old -o -f /bin/sh.old ]; then
  echo '/bin/bash.old already exists!?!?'
  echo 'aborting...'
  exit 1
fi
exit
# Apply Patch 1

if [ -d bash-fix ];then
  echo 'bash-fix directory already exists?'
  echo 'aborting...'
  exit 1
fi

mkdir bash-fix
cd bash-fix
curl https://opensource.apple.com/tarballs/bash/bash-92.tar.gz | tar zxf -
cd bash-92/bash-3.2
curl https://ftp.gnu.org/pub/gnu/bash/bash-3.2-patches/bash32-052 | patch -p0
cd ..
xcodebuild

# Apply Patch 2 from 9/26/2014 at 3:10 p.m. PDT

mv build/bash.build/Release/bash.build/DerivedSources/y.tab.* bash-3.2/
cd bash-3.2
curl https://ftp.gnu.org/pub/gnu/bash/bash-3.2-patches/bash32-053 | patch -p0
cd ..
xcodebuild

for shell in bash sh ; do
  if ! build/Release/$shell --version | grep '3.2.53(1)' >/dev/null 2>&1 ;then
    echo 'patched bash has wrong version !?!?'
    exit 1
  fi
done

sudo cp -p /bin/bash /bin/bash.old
sudo cp -p /bin/sh   /bin/sh.old

sudo cp build/Release/bash /bin
sudo cp build/Release/sh /bin

echo 'bash and sh have been patched.'
echo 'verify by running these commands and NOT seeing "vulnerable" string:'
echo "  env VAR='() { :;}; echo bash is vulnerable!' bash -c \"echo bash Test\""
echo "  env VAR='() { :;}; echo sh is vulnerable!'   sh -c \"echo sh Test\""
echo
echo "you can now delete bash-fix/ directory"

