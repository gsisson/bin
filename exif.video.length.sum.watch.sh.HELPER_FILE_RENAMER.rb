#!/usr/bin/env ruby
  
files=`ls -t1r Untitled*.avi Sequence*.mp4 2>/dev/null`
abort "no files found to process!" if files.empty?

files.each_line do |f|
  f.chomp!
  fext=File.extname(f)
  f=f.sub(/#{fext}/,'')
  while true do
    print "input new name for file \"#{f}#{fext}\"... "
    newf=gets.chomp
    next if newf.length == 0
    lastest_date_dir=`ls -td ????-??-?? 2>/dev/null`.split[0] # [-1]
    year=lastest_date_dir[0..3]  if lastest_date_dir
    month=lastest_date_dir[5..6] if lastest_date_dir
    if newf =~ /^20[01][0-9]-[0-9][0-9]-[0-9][0-9]$/
      puts "mkdir #{newf}"
      Dir.mkdir newf
      next
    end
    if newf =~ /^[0-9][0-9]-[0-9][0-9]$/
      if year.nil?
        puts "ERROR: unable to find an existing date-dir to get year from!"
        next
      end
      puts "mkdir #{year}-#{newf}"
      Dir.mkdir "#{year}-#{newf}"
      next
    end
    if newf =~ /^[0-9][0-9]$/
      if year.nil? || month.nil?
        puts "ERROR: unable to find an existing date-dir to get year and month from!"
        next
      end
      puts "mkdir #{year}-#{month}-#{newf}"
      Dir.mkdir "#{year}-#{month}-#{newf}"
      next
    end
    ext=
    newf=newf+fext #'.avi'
    if ! File.exist?(newf)
      puts "mv #{f}#{fext} #{newf}"
      File.rename "#{f}#{fext}", newf
      break
    end
    puts "ERROR: that file (#{newf}) already exists!  Try again!"
  end
end
puts "all done!"
