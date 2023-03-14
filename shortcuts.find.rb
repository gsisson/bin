#!/usr/bin/env ruby

# called from many dirs
#  => THIS SCRIPT
#    => mkshortcut.from.input.sh # to change?
#      => Cygwin/mkshortcut.exe  # to change?

require 'fileutils'
require '~/usr/ruby/lib/filesystem'
require '~/usr/ruby/lib/findvid'
require '~/usr/ruby/lib/check_for_non_links'
require '~/usr/ruby/lib/string_colorize'

DIR ='t:/RECYCLABLE/v/'

#video_extentions = /lnk$|mp3$|jpg$|jpeg$|txt$|xmp$|png$|sh$|proj$|gif$|url$|tif$|rb$|THM$|AAE$|psd$/i
 video_extentions = /f4v$|webm$|m2v$|m2t$|flv$|mts$|m4v$|avi$|3gp$|wmv$|mov$|mp4$|mpg$|mpeg$|mkv$/i

def usage(args = nil)
  name = File.basename(__FILE__)
  STDERR.puts("\n#{args}\n\n") if args != nil
  STDERR.puts "usage: #{name} TARGET"
  STDERR.puts "       where TARGET =~ '###target1.target2.getme.sh"
  puts "\033[041m (sleep 10) \033[0m"
  sleep 10
  exit 1
end

def mkshortcut_in_cwd(tgt)
  tgt = tgt.sub("t:/","/cygdrive/t/")
  _stdin, _stdout, _stderr, wait_thr = Open3.popen3('mkshortcut.exe', "#{tgt}")
  # wait_thr.value.exitstatus # (this will cause a long pause)
end

if ! Dir.exist?(DIR)
  STDERR.puts "Directory DNE! #{DIR}"
  puts "\033[041m (sleep 10) \033[0m"
  sleep 10
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
shortcuts_needed_here_hash={}
full_vids_with_path_plus_junk = FindVid.main(args)
full_vids_with_path = full_vids_with_path_plus_junk.select {|i| i !~ /jpg$|jpeg$|txt$|xmp$|png$|sh$|prproj$|lnk$/i } #  /prproj$|lnk$|sh$/i
full_vids_with_path.each do |full_vid_path|
  next if File.directory?(full_vid_path)
  vidname=File.basename(full_vid_path)
  ok=true
  args.each do |arg|
    if vidname !~ /#{arg}/i
      ok=false
      # break out of for look so we don't echo out $full_vid_path, since
      # it is missing this 'arg' (that it is required to include)
      break
    end
  end
  if ok
    # puts full_vid_path
    shortcuts_needed_here << full_vid_path
    if shortcuts_needed_here_hash[vidname]
      shortcuts_needed_here_hash[vidname] << full_vid_path
    else
      shortcuts_needed_here_hash[vidname] = [full_vid_path]
    end
  end
  #puts "-#{vidname}"
end

puts "found #{shortcuts_needed_here.size} shortcuts that could be here..."
count=shortcuts_needed_here_hash.keys.size
sub_lnks = Dir2.glob_i('**/*.lnk').select { |item| item =~ /\//}
sub_lnks.each do |sub_lnk|
  sub_lnk_base=File.basename(sub_lnk).sub(/.lnk$/,'')
  if shortcuts_needed_here_hash[sub_lnk_base]
    shortcuts_needed_here_hash.delete(sub_lnk_base)
  end
end
puts "found #{count-shortcuts_needed_here_hash.size} exist below already..."
size = shortcuts_needed_here_hash.size.to_s
if shortcuts_needed_here_hash.size == 0
  size=" #{size} ".bg_green
else
  size=" #{size} ".bg_red
end
puts "so making #{size} shortcuts..."

shortcuts_needed_here.each do |item|
  if shortcuts_needed_here_hash[File.basename(item)]
    # puts "+ mkshortcut_in_cwd(#{item})"
    mkshortcut_in_cwd(item)
  end
end
puts if shortcuts_needed_here_hash.size == 0

def shortcuts_remove_if_exist_in_subdir___but___update_them_first()
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
end

# no need to rebuild links below anymore, since ren2.sh builds them correctly now
going_to_rebuild_links_found_below_predicate = false
if going_to_rebuild_links_found_below_predicate
  if shortcuts_needed_here_hash.keys.size > 0
    puts " (sleep 1, so mkshortcut commands can finish)"
    sleep 1
  end
  #FS.shortcuts_remove_if_exist_in_subdir()
  #shortcuts_remove_if_exist_in_subdir___but___update_them_first()
end

puts "\033[042m (DONE) \033[0m"
sleep 2
