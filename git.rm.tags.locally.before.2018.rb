#!/usr/bin/env ruby

require '~/usr/ruby/lib/string_colorize.rb'

matcher='/201[67]'
puts 'Removing tags matching "#{matcher}"'

`git tag -l | grep -E '#{matcher}'`.split("\n").each_slice(100) do |batch|
  puts batch.size
  puts "+ git tag -d #{batch.join(' ')}"
  `git tag -d #{batch.join(' ')}`
end
