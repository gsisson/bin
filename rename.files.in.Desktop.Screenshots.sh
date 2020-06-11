#!/usr/bin/env bash

# this script is started by the double-clickable file:
# '~/Desktop/Screenshots/rename.files.in.Desktop.Screenshots.sh.command'
# which should contain the following:
#   
#   #!/usr/bin/env bash
#   cd $(dirname $0)
#   /Users/gsisson/usr/bin/rename.files.in.Desktop.Screenshots.sh

for f in * ; do
  if [[ "$f" =~ ^\ *[0-9]{4}\-[0-9]{2}-[0-9]{2}\ at\ [0-9]{2}\.[0-9]{2}\.[0-9]{2}\.png ]]; then
    t="${f# }"
    t="${t/ at /_}"
    echo + mv \"${f}\" \"${t}\"
    if [ "$work" != true ]; then
      echo;echo
    fi
    mv "${f}" "${t}"
    work=true
  fi
done

if [ "$work" = true ]; then
  exit
fi

echo
echo
echo "  no work to do..."
echo
echo
