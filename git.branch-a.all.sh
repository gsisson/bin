for d in aft* ctlz* tf-* ; do
  cd $d > /dev/null 2>&1
  echo "===== $d"
  git branch -a | grep '\*'
  cd - > /dev/null 2>&1
done
