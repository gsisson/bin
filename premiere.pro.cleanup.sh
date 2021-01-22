for d in \
  'T:\Premiere.Pro.Work\Adobe Premiere Pro Auto-Save' \
  'T:\Premiere.Pro.Work\Adobe Premiere Pro Preview Files' \
  'T:\Premiere.Pro.Work\Media Cache Files' \
  'T:\Premiere.Pro.Work\Media.Cache.Database\Media Cache' ; do
  cd "$d" || exit 1
  echo recycling content in ${d}...
  mkdir -p .delete_dir
  touch garbage_file
  mv * .delete_dir/
  mv   .delete_dir delete_dir
  ~/usr/bin/recycle.bat delete_dir
done
