#!/usr/bin/env ruby

# called from many dirs
#  => THIS SCRIPT
#    => mkshortcut.from.input.sh # to change?
#      => Cygwin/mkshortcut.exe  # to change?

require 'fileutils'
require '~/usr/ruby/lib/findvid'
require '~/usr/ruby/lib/check_for_non_links'

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

def mkshortcut_in_cwd(tgt)
  tgt = tgt.sub("t:/","/cygdrive/t/")
  _stdin, _stdout, _stderr, wait_thr = Open3.popen3('mkshortcut.exe', "#{tgt}")
  # wait_thr.value.exitstatus # (this will cause a long pause)
end

if ! Dir.exist?(DIR)
  STDERR.puts "Directory DNE! #{DIR}"
  exit 1
end

# puts 'check_for_non_links()'
# check_for_nonlinks(DIR, /\.lnk$|\.jpg$|\.txt$|\.sh$|\.prproj/)

if ARGV.size != 1
  usage
end

args=ARGV[0]
args=args.sub(/\.getem\.sh$/,'').sub(/getem\.sh$/,'')
args=args.sub(/^#*/,'').gsub(/\./,' ')
if args.length == 0
  pwd=Dir.pwd
  while File.basename(pwd) != '==GEN' do
    arg=File.basename(pwd)
    arg=arg.sub(/^@/,'')
    args="#{args} #{arg}"
    pwd=File.dirname pwd
  end
end

args=args.split()
shortcuts_needed_here=[]
full_vids_with_path_plus_junk = FindVid.main(args)
full_vids_with_path = full_vids_with_path_plus_junk.select {|i| i !~ /jpg$|jpeg$|txt$|xmp$|png$|sh$|prproj$|lnk$/i } #  /prproj$|lnk$|sh$/i
full_vids_with_path.each do |full_vid_path|
  next if File.directory?(full_vid_path)
  vidname=File.basename(full_vid_path)
  ok=true
  args.each do |arg|
    if vidname !~ /#{arg}/
      ok=false
      # break out of for look so we don't echo out $full_vid_path, since
      # it is missing this 'arg' (that it is required to include)
      break
    end
  end
  if ok
    # puts full_vid_path
    shortcuts_needed_here << full_vid_path
  end
  #puts "-#{vidname}"
end
#puts shortcuts_needed_here

print "making #{shortcuts_needed_here.size} shortcuts..."
shortcuts_needed_here.each do |item|
  #puts "+ mkshortcut_in_cwd(#{item})"
  mkshortcut_in_cwd(item)
end
if shortcuts_needed_here.size > 0
  puts " (sleep 1, so mkshortcut commands can finish)"
  sleep 1
end

# ~/usr/bin/remove.dups
lnks_below_full = Dir2.all_files_recursively()
lnks_below_full = lnks_below_full.select { |file| file =~ /\.lnk$/ } # only .lnk files
lnks_below_full = lnks_below_full.select { |file| file =~ /\// }  # not at top level (has a slash)
lnks_below={}
lnks_below_full.each do |lnk_full|
  lnk = File.basename(lnk_full)
  if lnks_below[lnk]
    lnks_below[lnk] << lnk_full
  else
    lnks_below[lnk] = [lnk_full]
  end
end

cp_cnt=0
rm_cnt=0
Dir2.glob_i_lnks().each do |lnk|
  # puts "checking for '#{lnk}' file..."
  if lnks_below[lnk]
    lnks_below[lnk].each do |lnk_to_refresh|
      # puts "+ cp #{lnk} #{lnk_to_refresh}"
      cp_cnt += 1
      FileUtils.cp(lnk,lnk_to_refresh)
    end
    rm_cnt += 1
    # puts "+ remove #{lnk}"
    FileUtils.rm(lnk)
  end
end

puts "updated    #{cp_cnt} files"
puts "cleaned up #{rm_cnt} files"
puts "(sleep 5)"
sleep 5
