#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

File.open("text.from.google.doc.txt", "rb:UTF-8") do |file|
  puts "char\tpinyin\tmeaning\t"
  file.each do |line|
    lines = %r{([^/]*)(/.*/)([^/]*)}.match(line)
    if lines
      char_pinyin_numbers=lines[1].split(' ')
      char=char_pinyin_numbers[0]
      pinyin=char_pinyin_numbers[1..-4].join(' ')
#      puts "char -> #{char} <-"
#      puts "pinyin -> #{pinyin} <-"
#      puts "meaning -> #{lines[2]} <-"
      puts "#{char}\t#{pinyin}\t#{lines[2]}"
    end
  end
end
