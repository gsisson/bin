#!/usr/bin/env ruby

#> Re: EXIF DateTimeTaken no milliseconds, why?
#> SubSecTime 
#> SubSecTimeOriginal 
#> SubSecTimeDigitized

require 'date'
require 'pp'
require 'open3'
require '~/usr/bin/ruby/String.color'
require '~/usr/bin/ruby/Dir2'
require '~/usr/bin/ruby/Image'

SENTINAL="SENTINAL_multiple_dates_ok(EXIF.FIX.RB).txt"

def array_to_quoted_string(arr)
  arr.map {|i| "'#{i}'"}.join(' ') #flatten to string of quoted strings
end

def date_of dt
  # "2015:01:19"                => "2015:01:19"
  # "2015:01:19 18:29:49-08:00" => "2015:01:19"
  # "2015:01:19 18:29:49"       => "2015:01:19"
  return "0000:00:00" if ! dt
  dt[0.."2015:01:19".length-1]
end

def time_of dt
  # "2015:01:19 18:29:49-08:00" => "18:29:49"
  # "2015:01:19 18:29:49"       => "18:29:49"
  return "00:00:00" if ! dt
  dt[0.."2015:01:19 18:29:49".length-1][-8..-1]
end

def valid_date_pieces?(year, month, day, hour, min, sec)
  return sec  >= 0    && sec  <= 59 &&
         min  >= 0    && min  <= 59 &&
         hour >= 0    && hour <= 23 &&
         day  >= 1    && day  <= 31 &&
         month>= 1    && month<= 12 &&
         year >= 1950 && year <= Time.new.year
end

def valid_datetime_prefix?(dt)
  # check date-time of format "2004:12:31 18:20:12"
  # return nil if invalid date (such as "2500:90:90 00:90:00")
  #   ex: good input: dt="2004:12:31 18:20:12"
  #   ex: bad input:  dt="2500:90:90 00:90:00"
  year =(dt)[0..3].to_i
  month=(dt)[5..6].to_i
  day  =(dt)[8..9].to_i
  hour =(dt)[11..12].to_i
  min  =(dt)[14..15].to_i
  sec  =(dt)[17..18].to_i
  return dt if valid_date_pieces?(year, month, day, hour, min, sec)
  return dt if valid_date_pieces?(year,     1, day, hour, min, sec) && month == 0
  return dt if valid_date_pieces?(year, month,   1, hour, min, sec) && day   == 0
  return dt if valid_date_pieces?(year,     1,   1, hour, min, sec) && month == 0 && day == 0
  nil
end

def exiftool_execute_CHUNK(args, files)
  files_flat=array_to_quoted_string(files)
  exiftool_output = `exiftool #{args} #{files_flat}`.split(/\r?\n/)
  if $?.exitstatus != 0
    puts "error with exiftool!" 
    exit 1
  end
  if files.count == 1
    # corner case... when exiftool processes only one image, it doesn't add the header
    # so we add it manually
    exiftool_output.unshift "======== #{files[0]}"
  else
    # when more than one file being worked on by exiftool, the last line
    # it outputs is a count of the files it worked on.  So, we remove that.
    exiftool_output.pop
  end
  exiftool_output
end

def exiftool_execute(args, files)
  # since we sometimes have too many files, and the arg list to exiftool
  # is too long for the shell, we break the work up into a number of commands
  files_work=files.dup
  n=400
  results=[]
  while files_work.size > 0 do
    #puts "files_work.size: #{files_work.size}"
    #puts "results.size:    #{results.size}"
    results.push *exiftool_execute_CHUNK(args, files_work[0..n-1])
    files_work.shift(n)
  end
  #puts "files_work.size: #{files_work.size}"
  #puts "results.size:    #{results.size}   (RETURNING)"
  results
end

def exiftool_remove_all_bad_tags( filename )
  cmd="exiftool -all= -tagsfromfile @ -all:all -unsafe '#{filename}'"
  puts "#>>> #{cmd}"
  Open3.popen2e(cmd) {|i,o,t|
    o.each do |line|
      puts "# => #{line.chomp}"
    end
    if t.value.exitstatus == 0
#     puts "# success!"
      return true 
    end
    puts "#"+" ERROR WITH EXIFTOOL (while removing bad tags)!".red.bold
  }
  false
end

def exiftool_execute_set_dto( proposed_date, filename )
  cmd1="exiftool '-DateTimeOriginal=#{proposed_date}'"
  cmd2="         '#{filename}'"
# cmd="exiftool '-DateTimeOriginal=#{proposed_date}' '#{filename}'"
  cmd="#{cmd1}#{cmd2}"
  puts "#>>> #{cmd1}"
  puts "#    #{cmd2}"
  res=[]
  tries=0
  while tries <=1 do
    Open3.popen2e(cmd) do |i,o,t|
      o.each do |line|
        res << line
        puts "# => #{line.chomp}"
      end
      tries+=1
      if t.value.exitstatus == 0
#       puts "# success!"
        return true 
      end
      if res.grep /Error: [minor] Bad InteropIFD directory/
        if Dir.pwd =~ /brians.photos/i
          exiftool_remove_all_bad_tags filename
          next
        end
      end
      if res.grep /Error: File not found/
        tries=999
      end
    end
  end
  puts "5"
  puts "#"+" ERROR WITH EXIFTOOL!".red.bold
  if res.grep /Error: [minor] Bad InteropIFD directory/
    puts "# (you might try purging all the 'bad' tags from the file with:"
    puts "#>   f='#{filename}'"
    puts "#>   exiftool -all= -tagsfromfile @ -all:all -unsafe \"$f\""
    puts "# )"
  end
  false
end

def most_freq_dto_from_local_filenames(images)
  return nil if images.count == 0
  dates=images.map do |f|
    f[0.."YYYY-MM-DD".length-1]
  end
  # find out which date occurs the most by creating a frequency map
  dates = Hash[*dates.group_by{ |v| v }.flat_map{ |k, v| [k, v.size] }].invert
  # return the most frequently occuring date
  dates[dates.keys.max].gsub(/-/,':')#.gsub(/:/,'-')
end

def most_freq_dto_from_local_files(images)
  exiftool_output=exiftool_execute("-s2 -DateTimeOriginal", images)
  prefix=/^DateTimeOriginal: /
  dates=exiftool_output.select do |l|
       l =~ /^DateTimeOriginal: /
  end.reject do |l|
       l =~ /^DateTimeOriginal: $/
  end.map do |l|
    l.sub(prefix,'').  # strip off the prefix
      sub(/ .*/,'')    # strip off the time (we just want the date)
  end.select do |l|
    valid_datetime_prefix?(l)
  end
  # find out which date occurs the most by creating a frequency map
  dates = Hash[*dates.group_by{ |v| v }.flat_map{ |k, v| [k, v.size] }].invert
  # return the most frequently occuring date
  return nil if dates.keys.count == 0
  dates[dates.keys.max].gsub(/-/,':')#.gsub(/:/,'-')
end

# Return the date, formated as "YYYY-MM-DD", that is encoded as a
# prefix in the current directory name.  If the prefix does not have
# the format "YYYY-MM-DD_", then stop and raise an error
def date_from_pwd()
  dt = datetime_from_filename("#{Date2.prefix_for_file(File.basename(Dir2.pwd))}_00:00:00")
  dt && dt[0.."YYYY-MM-DD".length-1]
end

def date_from_filename(filename)
  # verify filename starts with "YYYY-MM-DD_"
  pattern = /^(\d\d\d\d)[-\.]([\dX][\dX])[-\.]([\dX][\dX])_/
  pattern = /^(\d\d\d\d)[-\.]([\d][\d])[-\.]([\d][\d])_/
  return nil if ! match = filename.match(pattern)
  year, month, day = match.captures

# month   = '00' if month   == 'XX'
# day     = '00' if day     == 'XX'
  month   = '01' if month   == 'XX' || month   == '00'
  day     = '01' if day     == 'XX' || day     == '00'

  year    = year.to_i
  month   = month.to_i
  day     = day.to_i

  if day   >= 1    && day  <= 31 &&
     month >= 1    && month<= 12 &&
     year  >= 1950 && year <= Time.new.year
#   return filename[0.."YYYY-MM-DD".length-1].gsub(/-/,':')
    return "%4d-%02d-%02d" % [year, month, day]
  end
  return nil
end

def datetime_from_filename(filename)
  # verify filename starts with "YYYY-MM-DD_hh.mm.ss"
  pattern = /^(\d\d\d\d)[-\.]([\d][\d])[-\.]([\d][\d])_([\d][\d]).([\d][\d]).([\d])/
  return nil if ! match = filename.match(pattern)
  year, month, day, hours, minutes, seconds = match.captures

# month   = '00' if month   == 'XX'
# day     = '00' if day     == 'XX'
  month   = '01' if month   == 'XX' || month   == '00'
  day     = '01' if day     == 'XX' || day     == '00'
  hour    = '00' if hour    == 'XX'
  minutes = '00' if minutes == 'XX'
  seconds = '00' if seconds == 'XX'
  year    = year.to_i
  month   = month.to_i
  day     = day.to_i
  hour    = hour.to_i
  minutes = minutes.to_i
  seconds = seconds.to_i

  if day   >= 1    && day  <= 31 &&
     month >= 1    && month<= 12 &&
     year  >= 1950 && year <= Time.new.year
    return filename[0.."YYYY-MM-DD_hh.mm.ss".length-1]#.gsub(/[-\.]/,':')
  end
  return nil
end

def exiftool_value(line, tag)
  #puts "line:>>#{line}<<"
  #puts "tag :>>#{tag}<<"
  dt=line.sub("#{tag}: ",'') 
  #puts "dt:#{dt}"
  dt=case dt
     when "-" # exiftool will only return '-' when using "-f" option
       nil    #   and when the requested tag is missing from the exif data
       #   (otherwise nothing is returned, which is hard to parse)
     when "0000:00:00 00:00:00"
       nil
     else
       #puts "--> dt:#{dt}"
       #puts "--> valid_datetime_prefix? dt:#{valid_datetime_prefix? dt}"
       valid_datetime_prefix? dt
     end
end

$WIDTH=24

def format
  "# %#{$WIDTH}s %s\n"
end

def dashed_line
  puts format % ["-"*$WIDTH, "-"*(77-$WIDTH-1)]
end

def show_file_info_pat file, pattern
  pat1 = date_of(pattern)
  pat2 = time_of(pattern)
# show_file_info(file).gsub(/#{Regexp.quote(pattern)}/,"#{pattern}".green.bold)
  show_file_info(file).gsub(/#{Regexp.quote(pat1)}/,"#{pat1}".green.bold).gsub(/#{Regexp.quote(pat2)}/,"#{pat2}".green.bold)
end

def show_file_info file
  fmt = format
  dto=file[:date_time_original] && file[:date_time_original].red.bold
  dashed_line
  msg=""
# msg += fmt % ["-"*width,              "-"*(77-width-1)]
  msg += fmt % ["(date from pwd)",          $date_from_pwd]
  msg += fmt % ["(mf date from all DTOs)",  $most_freq_dto_from_local_files]
  msg += fmt % ["(mf date from filenames)", $most_freq_dto_from_local_filenames]
  msg += fmt % [:filename,              file[:filename]]
  msg += fmt % [:date_time_file_prefix, file[:date_time_file_prefix]] 
  msg += fmt % [:date_file_prefix,      file[:date_file_prefix]] 
  msg += fmt % [:date_time_original,    dto]
  msg += fmt % [:modify_date,           file[:modify_date]]
  msg += fmt % [:create_date,           file[:create_date]]
  msg += fmt % [:file_modify_date,      file[:file_modify_date]]
  msg
end

def exiftool_files_backup(file)
  ext=File.extname file
  flat="#{file}".gsub('/','=').sub(/^D:/i,'D')
# puts "# Renaming file..."
# puts "#   File.rename #{file}_original,"
# puts "#               d:/tmp/#{flat}_original.#{ext}"
  File.rename "#{file}_original", "d:/tmp/#{flat}_original.#{ext}"
# puts "#   cp -p #{file},"
# puts "#         d:/tmp/#{flat}"
  cmd="cp -p '#{file}' 'd:/tmp/#{flat}'"
  system cmd
end

def compatible_year?(date1, date2)
  return false if !date1 || !date2
  d1 = date1[0..3]
  d2 = date2[0..3]
  (0..3).each do |index|
    next if d1[index] == 'X' || d2[index] == 'X'
    next if d1[index] == d2[index]
    #puts "non compat year #{date1} #{date2}"
    return false
  end
  true
end

def compatible_month?(date1, date2)
  return false if !date1 || !date2
  d1 = date1[5..6]
  d2 = date2[5..6]
  (0..2).each do |index|
    next if d1[index] == 'X' || d2[index] == 'X'
    next if d1[index] == d2[index]
    #puts "non compat month #{date1} #{date2}"
    return false
  end
  true
end
def compatible_day?(date1, date2)
  return false if !date1 || !date2
  d1 = date1[8..9]
  d2 = date2[8..9]
  (0..2).each do |index|
    next if d1[index] == 'X' || d2[index] == 'X'
    next if d1[index] == d2[index]
    #puts "non compat day #{date1} #{date2}"
    return false
  end
  true
end

def compatible_ymd? file1, file2
  return compatible_year?(file1, file2) &&
         compatible_month?(file1, file2) &&
         compatible_day?(file1, file2)
end

def increment_datetime dto
  # 2002:03:14 06:27:18
  one_second = Rational(1, 86400)
  begin
    date = DateTime::strptime(dto,"%Y:%m:%d %H:%M:%S")
  rescue ArgumentError => e
    puts "#"+" ERROR: increment_datetime() called with bad dates!".red.bold
    puts "#        dto: =>#{dto}<="
    puts "# ABORTING!"
    puts e.backtrace
    exit 1
  end
  date += one_second
  date.strftime "%Y:%m:%d %H:%M:%S"
end

def find_next_non_conflicting_datetime all_dup_dtos, colliding_dto
  # puts "all_dup_dtos:  #{all_dup_dtos}"
  test_dto = colliding_dto
  #puts "test_dto: #{test_dto}"
  while true
    #puts "  collision? : #{test_dto}"
    if ! all_dup_dtos.include? test_dto
      #puts "    no! :-)"
      all_dup_dtos << test_dto
       #puts "FOUND SOLUTION"
       #puts "  (new) all_dup_dtos:  #{all_dup_dtos}"
       #puts "  (new) dto: #{test_dto}"
      return all_dup_dtos, test_dto
    else
       #puts "    yes :-("
    end
    test_dto = increment_datetime test_dto
  end
end

def to_dt_fmt_for_file(dt)
  Date2.corrected_prefix_for_file(dt)
end

def to_dt_fmt_for_exif(dt)
  tmp=dt
  if tmp.length == "YYYY-MM-DD".length
    tmp="#{tmp} 00:00:00"
  end    
  tmp.sub(/^(....)[-:\.](..)[-:\.](..)[ _\.](..)[-:\.](..)[-:\.](..)/,'\1:\2:\3 \4:\5:\6')
end

def datetime_difference_in_seconds date1Str, date2Str
  return 0 if ! date1Str || ! date2Str
  l=("YYYY-MM-DD_HH.MM.SS".length)-1
  d1=to_dt_fmt_for_file(date1Str[0..l])
  d2=to_dt_fmt_for_file(date2Str[0..l])
  return 0 if d1 == d2
  begin
    date1 = DateTime::strptime(d1,"%Y-%m-%d_%H.%M.%S")
    date2 = DateTime::strptime(d2,"%Y-%m-%d_%H.%M.%S")
  rescue ArgumentError => e
#   puts "# ERROR: datetime_difference_in_seconds() called with bad dates!"
#   puts "#        date1Str: =>#{date1Str[0..l]}<="
#   puts "#        date2Str: =>#{date2Str[0..l]}<="
#   puts "# ABORTING!"
   #puts e.backtrace
#   exit 1
    return 86400*666 # 666 days, a big number
  end 
  date1, date2 = date2, date1 if date1 > date2
  return (86400*(date2-date1)).to_i
end

def ppp(seconds)
  return "#{seconds} seconds" if seconds < 60
  minutes = seconds / 60
  seconds = seconds % 60
  return "#{minutes} minutes, #{seconds} seconds" if minutes < 60
  hours   = minutes / 60
  minutes = minutes % 60
  return "#{hours} hours, #{minutes} minutes, #{seconds} seconds" if hours < 24
  days    = hours  / 24
  hours   = hours % 24
  return "#{days} days, #{hours} hours, #{minutes} minutes, #{seconds} seconds"
end

def load_files_and_data()
  files = Dir2.globi_jpgs_cr2s
  # gather data on .jpgs and .cr2s
  return [[],[]] if files.count == 0
  $most_freq_dto_from_local_files     = most_freq_dto_from_local_files(files)
  $most_freq_dto_from_local_filenames = most_freq_dto_from_local_filenames(files)
  $date_from_pwd                      = date_from_pwd()
  exiftool_output=exiftool_execute(
    "-f -s2 -filename -DateTimeOriginal -CreateDate -ModifyDate -FileModifyDate",files)
  dtos=[]
  files=[]
  # we will read 6 lines of exiftool output, per loop (delimiter + filename + 4 dates)
  while (exiftool_output.size / 6) > 0  
    # "======== 2002-02-23_09.29.54_136-3683_IMG.JPG"
    exiftool_output.shift # throw away this line
    # "FileName: 2002-02-23_09.29.54_136-3683_IMG.JPG"
    filename=exiftool_output.shift.sub("FileName: ",'') 
    # next lines, have valid dates, bad date, zeroed-dates, or '-' or ''
    files << hash = {
      :filename              => filename,
      :full_file             => "#{Dir2.pwd}/#{filename}",
      :date_time_original    => exiftool_value(exiftool_output.shift, "DateTimeOriginal"),
      :create_date           => exiftool_value(exiftool_output.shift, "CreateDate"),
      :modify_date           => exiftool_value(exiftool_output.shift, "ModifyDate"),
      :file_modify_date      => exiftool_value(exiftool_output.shift, "FileModifyDate"),
      :date_time_file_prefix => datetime_from_filename(filename),
      :date_file_prefix      => date_from_filename(filename),
      :proposed_new_dto_filename => nil,
      :filename_less_prefix  => Date2.guess_and_remove_date_time_prefix(filename),
      :ddis                  => 0,
    }
    #pp(hash)
    dtos << hash[:date_time_original] if hash[:date_time_original]
    if hash[:date_time_file_prefix]
      hash[:ddis] = datetime_difference_in_seconds(
        hash[:date_time_file_prefix],hash[:date_time_original])
    elsif hash[:date_file_prefix]
      hash[:ddis] = datetime_difference_in_seconds(
        hash[:date_file_prefix],hash[:date_time_original])
    end
    if hash[:date_time_original] 
      dto_prefix="#{to_dt_fmt_for_file(hash[:date_time_original])}"
      n="#{dto_prefix}_#{hash[:filename_less_prefix]}"
      if n != filename
        hash[:proposed_new_dto_filename] = n
      end
    else
      if ! hash[:date_time_file_prefix]
        if hash[:date_file_prefix]
          hash[:proposed_new_dto_filename] =
            "#{hash[:date_file_prefix]}_00.00.00_#{hash[:filename_less_prefix]}"
        else
          if $date_from_pwd
            hash[:proposed_new_dto_filename] =
              "#{$date_from_pwd}_00.00.00_#{hash[:filename]}"
          end
        end
      end
    end
  end
  [files, dtos]
end

################################################################################
################################################################################
################################################################################
################################################################################

exit_status=0

################################################################################
### Ignore work in special directories
################################################################################

['/DCIM/','/PRIVATE/AVCHD/'].each do |dir|
  if Dir2.pwd =~ /#{Regexp.quote(dir)}/
    # do not process directories under /PRIVATE/AVCHD/ paths (they are video thumbnails)
    exit 0
  end
end

################################################################################
### check for _original
################################################################################

if Dir2.globi("*original").count > 0
  puts "# "+("WARNING!! NO SOLUTION! ".red.bold)+"Found _original files!  Aborting!"
  exit 1
end

################################################################################
### check for "Copy of" files
################################################################################

if Dir2.globi("*Copy of*").count > 0
  puts "# "+("WARNING!! NO SOLUTION! ".red.bold)+"Found 'Copy of' files!  Aborting!"
  exit 1
end

################################################################################
### check for files with only a date time prefix and an extension (no other file name)
################################################################################

files = Dir2.globi("*").select { |f| ! Dir.exist? f }
if files.count > 0
  failures = []
  files.each do |f|
    base=Date2.guess_and_remove_date_time_prefix(f)
    next if base !~ /image\..../
    # "file has a date/time prefix, but nothing else!
    tgt="#{Date2.corrected_prefix_for_file_x(f)}_#{base}"
    next if f =~ /^#{Regexp.quote(tgt)}$/
    if ! File.exist? tgt
      puts "File.rename #{f},"
      puts "            #{tgt}"
      File.rename f, tgt
    else
      failures << f
    end
  end
  if failures.size > 0
    puts "Problem renaming file!"
    failures.each do |f|
      puts "  #{f}"
    end
    puts "aborting... "
    exit 1
  end
end

################################################################################
### check for non-jpg files with no date-time prefix
################################################################################

files = Dir2.globi_images_and_text.select { |f| ! Dir.exist? f }
if files.count > 0
  failures = []
  prefix=Date2.prefix_for_file(File.basename(Dir2.pwd))
  files.each do |f|
    next if f =~ /jpe?g$/i
    next if f == SENTINAL
    next if f != Date2.guess_and_remove_date_time_prefix(f)
    # no prefix
    # so, add the date-time from current dir
    # (unless the file has a matching .jpg here too)
    b = f.sub(/#{Regexp.quote(File.extname(f))}$/,'')
    if File.exist?("#{b}.jpg") || File.exist?("#{b}.jpeg")
#     puts "Not adding date prefix, since .jpg version of file exists..."
#     puts "   #{f}"
    end
    # rename the file and add the prefix
    if prefix == nil
      puts "#"
      puts "# "+"Error: file has no date-time prefix,".red.bold
      puts "# "+"       and unable to determine date from PWD"
      puts "# "+"aborting..."
      exit 1
      end
    tgt="#{prefix}_00.00.00_#{f}"
    if ! File.exist? tgt
      puts "File.rename #{f},"
      puts "            #{tgt}"
      File.rename f, tgt
    else
      failures << f
    end
  end
  if failures.size > 0
    puts "Problem renaming file!"
    failures.each do |f|
      puts "  #{f}"
    end
    puts "aborting... "
    exit 1
  end
end

################################################################################
### check for filenames that are like
###   2008.10.11.12-23-34.file.jpg and rename to
###   2008-10-11_12.23.34_file.jpg
###  and
###   2008.10.11.file.jpg and rename to
###   2008-10-11_00.00.00_file.jpg
################################################################################

files = Dir2.globi("*").select { |f| ! Dir.exist? f }
if files.count > 0
  failures = []
  files.each do |f|
    prefix=Date2.guess_and_return_date_time_prefix(f)
    #puts "prefix: #{prefix}"
    base=Date2.guess_and_remove_date_time_prefix(f)
    #puts "base: #{base}"
    if prefix && base
      if ! Date2.valid_date?(prefix) && ! Date2.valid_date_time?(prefix)
        puts "#"+" ERROR: invalid date-time prefix????".red.bold
        puts "#   file: #{f}"
        exit 1
      end
      prefix = to_dt_fmt_for_file(prefix)
      #puts "new prefix: #{prefix}"
      if Date2.valid_date_time?(prefix)
        tgt="#{prefix}_#{base}"
      else
        tgt="#{prefix}_00.00.00_#{base}"
      end
      #puts "tgt: #{tgt}"
      next if f =~ /^#{Regexp.quote(tgt)}$/
      if ! File.exist? tgt
        puts "File.rename #{f},"
        puts "            #{tgt}"
        File.rename f, tgt
      else
        failures << f
      end
    end
  end
  if failures.size > 0
    puts "Problem renaming file!"
    failures.each do |f|
      puts "  #{f}"
    end
    puts "aborting... "
    exit 1
  end
end

################################################################################
### check for .pngs, and convert them
################################################################################

files = Dir2.globi("*.{png}").select { |f| ! Dir.exist? f }
if files.count > 0
  failures = []
  files.each do |f|
    jpg=f.sub(/png/i,'jpg')
    if ! File.exist? jpg
      if ! Image.convert_png_to_jpg f, jpg
        puts 1
        failures << f
      end
    end
  end
  if failures.size > 0
    puts "Problem comverting PNG files to JPG!"
    failures.each do |f|
      puts "  #{f}"
    end
    puts "aborting... "
    exit 1
  end
end

################################################################################
### check for .gifs, and convert them
################################################################################

files = Dir2.globi("*.{gif}").select { |f| ! Dir.exist? f }
if files.count > 0
  failures = []
  files.each do |f|
    jpg=f.sub(/gif/i,'jpg')
    if ! File.exist? jpg
      if ! Image.convert_gif_to_jpg f, jpg
        puts 1
        failures << f
      end
    end
  end
  if failures.size > 0
    puts "Problem comverting GIF files to JPG!"
    failures.each do |f|
      puts "  #{f}"
    end
    puts "aborting... "
    exit 1
  end
end

################################################################################
### gather data on .jpgs/.cr2s
################################################################################

files, dtos = load_files_and_data()
# exit if there are no files here
if files.count == 0
  #puts "# No JPG/CR2 files to work on!"
  exit 0
end

################################################################################
### Decide if we can rename files, based on DTO info, or valid proposed new names
################################################################################

needs_dto                      = []
renames                        = []
renames_collision              = []
renames_way_off                = []
renames_no_known_dto_prefix           = []
renames_no_known_dto_prefix_collision = []

files.each do |f|
  #pp(f)
  if f[:proposed_new_dto_filename]
    if f[:date_time_original]
      limit=10
      #limit=20000000
      if (f[:ddis] <= limit) || ((f[:ddis]-3600) <= limit)
        # Rename Files To have correct DTO prefix, if off by <= {limit} seconds
        if File.exist? f[:proposed_new_dto_filename]
          renames_collision << f
        else
          renames << f
        end
      else
        renames_way_off << f
      end
    else
      # Rename Files with no known DTO prefix, based on proposed name
      if File.exist? f[:proposed_new_dto_filename]
        renames_no_known_dto_prefix_collision << f
      else
        renames_no_known_dto_prefix << f
      end
    end
  else
    # no new proposed filename, since the existing file name is fine
    # but, there may be no dto, so we ought to set the TDO of the file
    if ! f[:date_time_original]
      needs_dto << f
    end
  end  
end

#puts "needs_dto.count: #{needs_dto.count}"
#puts "renames.count: #{renames.count}"
#puts "renames_collision.count: #{renames_collision.count}"
#puts "renames_way_off.count: #{renames_way_off.count}"
#puts "renames_no_known_dto_prefix.count: #{renames_no_known_dto_prefix.count}"
#puts "renames_no_known_dto_prefix_collision.count: #{renames_no_known_dto_prefix_collision.count}"

### Warn if correct DTO prefix, but differs from filename by > {limit}, and ABORT
################################################################################

if renames_way_off.count > 0
  puts "#"+" !! ERROR: THESE #{renames_way_off.count} files are WAY OFF on filename<->DTO!".red.bold
  puts "# "
  puts 'if [ "$1" = "-opt1" ];then #'+" -opt1: prefix <= DTO".cyan.bold
  renames_way_off.each do |f|
    puts "#   replace prefix with DTO:"
    puts "#     new fn (from DTO): "+"#{f[:proposed_new_dto_filename]}".green.bold
    puts "#     old fn:            "+"#{f[:filename]}".red.bold
    puts "#     (off by: "+"#{ppp(f[:ddis])}".cyan.bold+")"
    puts "   mv '#{f[:filename]}' '#{f[:proposed_new_dto_filename]}'"
  end
  puts 'fi'
  puts 'if [ "$1" = "-opt2" ];then #'+" -opt2: DTO <= prefix".cyan.bold
  renames_way_off.each do |f|
    l="YYYY-MM-DD_00.00.00".length
    proposed_dto2 = to_dt_fmt_for_exif(f[:filename][0..(l-1)])
    puts "#   re-write DTO based on prefix"
    puts "#     old DTO: "+"#{f[:date_time_original]}".red.bold
    puts "#     new DTO: "+"#{proposed_dto2}".green.bold
    puts "   exiftool '-DateTimeOriginal=#{proposed_dto2}' '#{f[:filename]}'"
  end
  puts "   mv *_original d:/tmp/"
  puts 'fi'
  puts "# "
  puts "# Fix the problems and run again!"
  exit 1
end

### Report planned renames that would cause a collision, and ABORT
################################################################################

if renames_collision.count > 0 || renames_no_known_dto_prefix_collision.count > 0
  if renames_collision.count > 0
    puts "#"+" !! THESE #{renames_collision.count} files can NOT be renamed, due to target file existence!".red.bold
    renames_collision.each do |f|
      puts "#  File.rename #{f[:filename]}, #{f[:proposed_new_dto_filename]}"
    end
  end
  if renames_no_known_dto_prefix_collision.count > 0
    puts "# !! THESE #{renames_no_known_dto_prefix_collision.count} files can NOT be renamed, due to target file existence!"
    renames_no_known_dto_prefix_collision.each do |f|
      puts "####  File.rename #{f[:filename]}, #{f[:proposed_new_dto_filename]}"
    end
  end
  puts "# "
  puts "# Fix the problems and run again!"
  exit 1
end

### Rename Files with correct DTO (off less than the limit)
################################################################################

stop=false
if renames.count > 0
  puts "# Renaming #{renames.count} files..."
  renames.each do |f|
    puts "#   File.rename #{f[:filename]},"
    puts "#               #{f[:proposed_new_dto_filename]}"
    puts "#     (off by #{ppp(f[:ddis])})" if f[:ddis] > 0
    if File.exists? f[:proposed_new_dto_filename]
      stop=true
      puts "# !! THIS file can NOT be renamed, due to target file existence!"
      puts "#  File.rename #{f[:filename]}, #{f[:proposed_new_dto_filename]}"
      next
    end
    if f[:filename] =~ /jpg$/i
      ['png','gif'].each do |ext|
        if File.exists? f[:filename].sub(/jpg$/i,ext)
          puts "#   File.rename #{f[:filename].sub(/jpg$/i,ext)},"
          puts "#               #{f[:proposed_new_dto_filename].sub(/jpg$/i,ext)}"
          if File.exists? f[:proposed_new_dto_filename].sub(/jpg$/i,ext)
            stop=true
            puts "# !! THIS file can NOT be renamed, due to target file existence!"
            puts "#  File.rename #{f[:filename].sub(/jpg$/i,ext)}, #{f[:proposed_new_dto_filename].sub(/jpg$/i,ext)}"
            next
          end
          File.rename f[:filename].sub(/jpg$/i,ext), \
            f[:proposed_new_dto_filename].sub(/jpg$/i,ext)
          exit_status=42
        end
      end
    end
    File.rename f[:filename], f[:proposed_new_dto_filename]
    exit_status=42
    # now, update the file name in the hash, because otherwise we will be 
    # storing an old filename, which will cause time-updates below to fail
    f[:filename] = f[:proposed_new_dto_filename]
  end
end
exit 1 if stop

### Rename Files with no valid DTO prefix already (based on proposed)
################################################################################

if renames_no_known_dto_prefix.count > 0
  puts "# Renaming #{renames_no_known_dto_prefix.count} files..."
  renames_no_known_dto_prefix.each do |f|
    puts "   File.rename #{f[:filename]},"
    puts "               #{f[:proposed_new_dto_filename]}"
    if File.exists? f[:proposed_new_dto_filename]
      stop=true
      puts "# !! THIS file can NOT be renamed, due to target file existence!"
      puts "#  File.rename #{f[:filename]}, #{f[:proposed_new_dto_filename]}"
    else
      File.rename f[:filename], f[:proposed_new_dto_filename]
      exit_status=42
    end
    proposed_dto = to_dt_fmt_for_exif(
      f[:proposed_new_dto_filename][0..("YYYY-MM-DD_00.00.00".length-1)])
    if exiftool_execute_set_dto( proposed_dto, f[:proposed_new_dto_filename] )
      exit_status=42
      exiftool_files_backup "#{Dir2.pwd}/#{f[:proposed_new_dto_filename]}"
    end
  end
end
exit 1 if stop

################################################################################
### Handle files missing DTO, but with DT prefix -- set the DTO
################################################################################

if needs_dto.count > 0
  puts "# "+"Found files missing DTO, but with DT prefix -- set the DTO".cyan.bold
  needs_dto.each do |f|
    if f[:date_time_file_prefix]
      dtf=to_dt_fmt_for_exif(f[:date_time_file_prefix])
      puts "# setting DTO in file #{f[:filename]}"
      puts "#                  to #{dtf}"
      if exiftool_execute_set_dto( dtf, f[:filename] )
        exit_status=42
        exiftool_files_backup "#{Dir2.pwd}/#{f[:filename]}"
      end
    else
      puts "# UNABLE TO GUESS TDO! (for file: #{f[:filename]})"
    end
  end
end

################################################################################
### Handle files with duplicate DTOs (as this causes Flickr upload sync clashes)
################################################################################

if false
  dups = dtos.group_by{ |e| e }.select { |k, v| v.size > 1 }
  if dups.count > 0
    # puts "# "+"Found duplicate DateTimeOriginal values!".cyan.bold
    dups=dups.keys
    dup_hash={}
    dups.each do |dup|
      dup_hash[dup] = []
    end
    dupfiles=files.select do |file|
      if dups.include? file[:date_time_original] 
        dup_hash[file[:date_time_original]] << file
      end
    end
    dup_hash.each do |dup, files|
  #   puts ("#"*79)
      puts "# "+"Duplicate DateTimeOriginal value of \"#{dup}\" found #{files.size} times:".cyan.bold
      n=files.count
      files.each do |hit|
        n-=1
        if n == files.count-1
  #       puts show_file_info_pat hit, hit[:date_time_original]
          next 
        end
  #     dtos, proposed_date = find_next_non_conflicting_datetime dtos, hit[:date_time_original]
  #     dashed_line
        if exiftool_execute_set_dto( proposed_date, hit[:filename] )
          exit_status=42
          exiftool_files_backup "#{hit[:filename]}"
        end
  #     puts "#"
      end
    end
  end
end

################################################################################
### Check for files in the wrong directory
################################################################################

files, dtos = load_files_and_data()

files_in_wrong_dir = []

files.each do |file|
  if ! File.exist?(SENTINAL)
    if !compatible_ymd?( file[:date_time_original], $date_from_pwd ) #&&
      puts "not compatible:"
      puts "  file[:date_time_original]: #{file[:date_time_original]}"
      puts "  $date_from_pwd:            #{$date_from_pwd}"
      files_in_wrong_dir << file
      next
    end
  end
end

################################################################################
### Handle files in the wrong directory
################################################################################

if files_in_wrong_dir.count > 0
  puts "# "
  puts "# "+"ERROR: #{files_in_wrong_dir.count} FILES IN WRONG DIR!".cyan.bold
  puts "# "+"  DTO and file prefix match, but don't gibe with directory name".red.bold
  puts "# "+"    #{Dir2.pwd}".red.bold
  puts "# "+"  either: "+"move files to proper directory".cyan.bold
  puts "# "+"      or: "+"\"touch '#{SENTINAL}'\"".green
  puts "#  dates found:"
  files_in_wrong_dir.map do |f|
    f[:date_file_prefix]
  end.uniq.each do |f|
    puts "#     #{f}"
  end
  exit 1
end

exit exit_status
