#!/usr/bin/env ruby
$LOAD_PATH << "#{ENV['HOME']}/usr/ruby/lib"
load 'osx_terminal.rb'

terminal = (RUBY_PLATFORM =~ /darwin/) ? OsxTerminal.new : raise("unsupported platform")
terminal.set_selected_tab_title ARGV.join ' '
