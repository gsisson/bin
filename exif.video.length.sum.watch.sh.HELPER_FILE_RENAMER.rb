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
    if newf =~ /20[01][0-9]-[0-9][0-9]-[0-9][0-9]/
      puts "mkdir #{newf}"
      Dir.mkdir newf
    else
      ext=
      newf=newf+fext #'.avi'
      if ! File.exist?(newf)
        puts "mv #{f}#{fext} #{newf}"
        File.rename "#{f}#{fext}", newf
        break
      end
      puts "THAT FILE (#{newf}) ALREADY EXISTS!  Try again!"
    end
  end
end
puts "all done!"
