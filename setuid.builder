#!/usr/bin/env bash
. ~/.bashrc

if [ -z "$1" ]; then
  example="${HOME}/usr/bin/script-needing-root"
  echo "usage: $(basename $0) <path_to_other_program_or_script>"
  echo "   ex: $(basename $0) $example"
  echo "       this will do the following:"
  echo "       - verify the prog/script exists"
  echo "       - build an executable: $(basename $example)"
  echo "         and drop it in the current directory."
  exit 1
fi

prog="$1"
if [ ! -f "${prog}" ]; then
  echo "ERROR: cannot find file '${prog}'!"
  exit 1
fi
case "$prog" in
  /*);;
  *) echo "ERROR: please pass an absolute path to the program!"
     exit 1;;
esac

exe=$(basename "$prog")

if [ -f "${exe}" ]; then
  echo "ERROR: planned output file of '${exe}' already exists in this directory!"
  exit 1
fi

if [ -f "${exe}.c" ]; then
  echo "ERROR: planned tempfile of '${exe}.c' already exists!"
  exit 1
fi

trap "rm -f ${exe}.c" EXIT

cat <<EOF | sed -e 's:PROG_NAME:'"${prog}"':' > "${exe}.c"
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>

int main(int argc, char **argv) {
//char *prog_path = "/some_path/to/script";
  char *prog_path = "PROG_NAME";

  setegid(getgid());
  seteuid(getuid());

  setegid(0); setgid(0);
  seteuid(0); setuid(0);
  if (execv(prog_path, argv) < 0) {
    perror("execv:");
    printf("  execv(\"%s\")\n",prog_path);
    exit(1);
  }
  exit(0);
}
EOF

cmd="cc ${exe}.c -o ${exe}"
echo + $cmd
$cmd
if [ $? != 0 ]; then
  echo
  echo "Error in generated program (${exe}.c)!"
  echo
  trap "ls -l ${exe}.c" EXIT
  exit $?
fi

echo + chown root "${exe}"
if [ "$EUID" != '0' ]; then
  echo "must run as root!"
  trap "rm -f ${exe}.c ${exe}" EXIT
  exit 1
fi
chown root "${exe}"
if [ $? != 0 ]; then
  echo "ERROR!"
  exit 1
fi

echo + chmod 4454 "${exe}"
       chmod 4454 "${exe}" # execute only for the group
if [ $? != 0 ]; then
  echo "ERROR!"
  exit 1
fi

ls -l "$PWD/${exe}"

echo "# mv ${exe} ~/usr/bin/"
echo "# run with '${exe}' <whatever args>"
