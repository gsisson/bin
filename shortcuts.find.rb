#!/usr/bin/env ruby

# called from many dirs
#  => THIS SCRIPT
#    => mkshortcut.from.input.sh # to change?
#      => Cygwin/mkshortcut.exe  # to change?

#require '~/usr/ruby/lib/dir2.rb'
#require '~/usr/ruby/lib/file_symlink'
#require '~/usr/ruby/lib/filesystem'
require '~/usr/ruby/lib/findvid'
require '~/usr/ruby/lib/check_for_non_links'
#require 'clipboard' #gem install clipboard
require 'open3'

DIR ='t:/RECYCLABLE/v/'

#video_extentions = /lnk$|mp3$|jpg$|jpeg$|txt$|xmp$|png$|sh$|proj$|gif$|url$|tif$|rb$|THM$|AAE$|psd$/i
 video_extentions = /f4v$|webm$|m2v$|m2t$|flv$|mts$|m4v$|avi$|3gp$|wmv$|mov$|mp4$|mpg$|mpeg$|mkv$/i

def usage(args = nil)
  name = File.basename(__FILE__)
  STDERR.puts("\n#{args}\n\n") if args != nil
  STDERR.puts "usage: #{name} TARGET"
  STDERR.puts "       where TARGET =~ '###target1.target2.getme.sh"
  exit 1
end

if ! Dir.exist?(DIR)
  STDERR.puts "Directory DNE! #{DIR}"
  exit 1
end

# puts 'check_for_non_links()'
# check_for_nonlinks(DIR, /\.lnk$|\.jpg$|\.txt$|\.sh$|\.prproj/)

puts ARGV.size
if ARGV.size != 1
  usage
end

args=ARGV[0]
args=args.sub(/\.getem\.sh$/,'').sub(/getem\.sh$/,'')
args=args.sub(/^#*/,'').gsub(/\./,' ')
if args.length == 0
  pwd=Dir.pwd
  puts pwd
  while File.basename(pwd) != '==GEN' do
    arg=File.basename(pwd)
    arg=arg.sub(/^@/,'')
    args="#{args} #{arg}"
    pwd=File.dirname pwd
  end
end

vids_n_stuff = FindVid.main(args.split())
#puts vids_n_stuff
vids = vids_n_stuff.select {|i| i !~ /jpg$|jpeg$|txt$|xmp$|png$|sh$|prproj$|lnk$/i } #  /prproj$|lnk$|sh$/i
vids.each do |vid|
  bname=File.basename(vid)
  #puts "-#{vid}"
end

__END__

findvid $args | grep -Eiv '(prproj$|lnk$|sh$)' | while read full_vid_path; do
  vid=$(basename "$full_vid_path")
  for arg in $args LAST_ITEM; do
    if [ "$arg" = LAST_ITEM ]; then
      echo $full_vid_path
    else
      if [[ $vid =~ $arg ]]; then
        :
      else
        # break out of for look so we don't echo out $full_vid_path, since
        # it is missing this 'arg' (that it is required to include)
        break
      fi
    fi
  done
done | mkshortcut.from.input.sh

~/usr/bin/remove.dups
exit

mkdir -p _
for f in *.lnk; do
  if find . -type f | grep '/.*/' | grep "/$f" > /dev/null 2>&1 ; then
    # remove, since found in a sub-dir
    rm "$f"
  else
    :
    # keep, since not found in a sub-dir
  fi
done
