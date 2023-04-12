for d in aft* ctlz* tf-* sand* sonar* terraform-* ; do
  cd $d > /dev/null 2>&1
  echo "===== $d"
  git pull --rebase
  cd - > /dev/null 2>&1
done
