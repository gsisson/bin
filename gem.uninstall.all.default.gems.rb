#!/usr/bin/env ruby

puts
puts "  NOTE: This utility removes all \"system gems\" (gems not installed by bundle)."
puts "        It does so by cd'ing to /tmp (a non-project directory), listing all"
puts "        gems and uninstalling them one-by-one.   Some gems are \"default gems\""
puts "        and cannot be uninstalled."
puts

Dir.chdir '/'

list=IO.popen "gem list"

while versions = list.gets
  abort if versions.nil?
  versions = versions.gsub(/[\(\),]/,'').split
  gem = versions.shift
  for version in versions
    cmd = "gem uninstall --executables -I #{gem} -v#{version} 2>/dev/null"
    puts cmd
    system cmd
    puts "  uninstall failed (probably a default gem)" if $?.exitstatus == 1
  end
end
