#!/usr/bin/env ruby

require 'colorize'

class << String
  alias_method :old_mode_codes, :mode_codes
  def mode_codes
    if ! @new_codes
      new_codes = {
        :dim       => 2,
        :italic    => 3,
        :overline  => 53, # doesn't work on Mac: Terminal nor iTerm2
      }
      @new_codes = new_codes.merge(old_mode_codes)
      String::modes_methods
      @initialized = true
    end
    @new_codes
  end
end
class String
  #def colors_from_hash(match, hash)
  #  match[0] = mode(hash[:mode]) if mode(hash[:mode])
  #  match[1] = color(hash[:color]) if color(hash[:color])
  #  match[2] = background_color(hash[:background]) if background_color(hash[:background])
  #end
end

puts "tests..."
puts
puts "  -->\033[03;04;32mONE\033[0mTWO\033[01;03;04;05;93;41;mTHREE\033[0m<-- raw (*2)"
puts '  --------------'
puts "  -->"+"ONE".green.underline+"TWO"+"THREE".light_yellow.on_red+"<-- (simple)"
puts "  -->"+"ONE".green.underline+"TWO"+"THREE".light_yellow.on_red.underline+"<-- underline"
puts "  -->"+"ONE".green.underline+"TWO"+"THREE".light_yellow.on_red.bold+"<-- bold"
puts "  -->"+"ONE".green.underline+"TWO"+"THREE".light_yellow.on_red.blink+"<-- blink"
puts "  -->"+"ONE".green.underline+"TWO"+"THREE".light_yellow.on_red.italic+"<-- italic (*2)"
puts "  -->"+"ONE".green.underline+"TWO"+"THREE".light_yellow.on_red.dim+"<-- dim (*1)"
puts "  -->"+"ONE".green.underline+"TWO"+"THREE".light_yellow.on_red.overline+"<-- overline (*1,*2)"
puts "  -->"+"ONE".green.underline+"TWO"+"THREE".light_yellow.on_red.hide+"<-- hide (*1)"
puts
puts "   (*1) does not work on Mac iTerm2"
puts "   (*2) does not work on Mac Terminal"
puts "   all work on 'Cygwin Mintty' and 'Cygwin Terminal'"
puts "   but none work with bash in CMD shell."

# puts String.color_samples
