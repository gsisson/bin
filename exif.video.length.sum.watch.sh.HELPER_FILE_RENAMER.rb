#!/usr/bin/env ruby
  
files=`ls -t1r Untitled*.avi Sequence*.mp4 2>/dev/null`
abort "no files found to process!" if files.empty?

files.each_line do |f|
  f.chomp!
  fext=File.extname(f)
  f=f.sub(/#{fext}/,'')
  while true do
    puts  "input new name for file \"#{f}#{fext}\""
    print "  ex: 12.23.25 (for 12:23:23) : "
    newf=gets.chomp
    next if newf.length == 0
    lastest_date_dir=`ls -td ????-??-?? 2>/dev/null`.split[0] # [-1]
    puts "+ lastest_date_dir: #{lastest_date_dir}"
    year=lastest_date_dir[0..3]  if lastest_date_dir
    month=lastest_date_dir[5..6] if lastest_date_dir
    puts "+ year:  #{year}"
    puts "+ month: #{month}"
    if newf =~ /^20[01][0-9]-[0-9][0-9]-[0-9][0-9]$/
      puts '+ matches /^20[01][0-9]-[0-9][0-9]-[0-9][0-9]$/'
      if Dir.exist? newf
        puts "(dir '#{newf}' already exists)"
      else
        puts "+ mkdir '#{newf}'"
        Dir.mkdir newf
      end
      next
    end
    if newf =~ /^[0-9][0-9]-[0-9][0-9]$/
      puts '+ matches /^[0-9][0-9]-[0-9][0-9]$/'
      if year.nil?
        puts "ERROR: unable to find an existing date-dir to get year from!"
        next
      end
      if Dir.exist? "#{year}-#{newf}"
        puts "(dir '#{year}-#{newf}' already exists)"
      else
        puts "+ mkdir #{year}-#{newf}"
        Dir.mkdir "#{year}-#{newf}"
      end
      next
    end
    if newf =~ /^[0-9][0-9]$/
      puts '+ matches /^[0-9][0-9]$/'
      if year.nil? || month.nil?
        puts "ERROR: unable to find an existing date-dir to get year and month from!"
        next
      end
      if Dir.exist? "#{year}-#{month}-#{newf}"
        puts "(dir '#{year}-#{month}-#{newf}' already exists)"
      else
        puts "mkdir #{year}-#{month}-#{newf}"
        Dir.mkdir "#{year}-#{month}-#{newf}"
      end
      next
    end
    ext=
    newf=newf+fext #'.avi'
    puts "newf: #{newf}"
    if ! File.exist?(newf)
      puts "+ mv #{f}#{fext} #{newf}"
      File.rename "#{f}#{fext}", newf
      break
    end
    puts "ERROR: that file (#{newf}) already exists!  Try again!"
  end
end
puts "all done!"
