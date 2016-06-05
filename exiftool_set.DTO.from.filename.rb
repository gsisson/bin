#!/usr/bin/env ruby

require_relative '../ruby/lib/dir2'
require_relative '../ruby/lib/date2'

def to_dt_fmt_for_exif(dt)
  dt.sub(/^(....)-(..)-(..)_(..).(..).(..)/,'\1:\2:\3 \4:\5:\6')
end

if ARGV.count == 0
  puts "usage: #{File.basename(__FILE__)}: <files>"
  abort
end

if ARGV.count > 0
  ARGV.each do |f|
    proposed_dto = Date2.prefix_for_file f
    if proposed_dto == nil
      puts "no prefix found for file \"#{f}\""
      next
    end
    if ! Date2.valid_date_time? proposed_dto
      proposed_dto += "_00.00.00"
    end
    proposed_dto = to_dt_fmt_for_exif proposed_dto
    puts "# setting DTO to \"#{proposed_dto}\" for \"#{f}\""
    cmd="exiftool '-DateTimeOriginal=#{proposed_dto}' '#{f}'"
    puts "+ #{cmd}"
    system cmd
  end
end
