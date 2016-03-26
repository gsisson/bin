#!/usr/bin/env ruby

# echo -e "\033[04;53;31;43m" underline, overline, red on yellow "\033[0m"
# echo -e "-->\033[03;04;32mONE\033[0mTWO\033[01;03;04;05;93;41;mTHREE\033[0m<--"
#                                             ^  ^  ^  ^  ^  ^
#                                             bold  underline^
#                                                italic^  YEL^
#                                                      blink red
#                                             6 code prefixes (test this on PC)
#                                               - this would not work with colorize gem
#                                                 since it only expects 3 color/mode #s max

def usage()
  $stderr.puts "usage: #{File.basename(__FILE__)} [background color]"
  abort
end

def header() 
  puts "# in bash: must use 'echo -e'"
  puts "# in bash: must use '\\033' for escape (not '\\e')"
  puts "#          (zsh can use '\\e')"
end

def foreground_codes()
  {#'black'     => 30+0,  'grey'        => 30+60 (offset is 30)
    'black'     => 30,    'grey'        => 90,
    'red'       => 31,    'lite_red'    => 91,
    'green'     => 32,    'lite_green'  => 92,
    'yellow'    => 33,    'lite_yellow' => 93,
    'blue'      => 34,    'lite_blue'   => 94,
    'magenta'   => 35,    'lite_magenta'=> 95,
    'cyan'      => 36,    'lite_cyan'   => 96,
    'lite_grey' => 37,    'white'       => 97,
    'default'   => 39,
  }
end

def background_codes()
  {#'black_background'     => 40+0,      'grey_background'         =>  40+60 (offset is 40)
    'black_background'     => 40,        'grey_background'         => 100,
    'red_background'       => 41,        'lite_red_background'     => 101,
    'green_background'     => 42,        'lite_green_background'   => 102,
    'yellow_background'    => 43,        'lite_yellow_background'  => 103,
    'blue_background'      => 44,        'lite_blue_background'    => 104,
    'magenta_background'   => 45,        'lite_magenta_background' => 105,
    'cyan_background'      => 46,        'lite_cyan_background'    => 106,
    'lite_grey_background' => 47,        'white_background'        => 107,
    'default'              => 49,
  }
end

def normalize_widths(hash)
  codes = hash
  key_width=0
  val_width=0
  codes.keys.each do |key|
    val = codes[key]
    key_width=[key_width,key.to_s.size].max
    val_width=[val_width,val.to_s.size].max
  end
  key_fmt_str= "%#{key_width}s"
  val_fmt_str= "%0#{val_width}d"
  hash2={}
  codes.keys.each do |key|
    val = codes[key]
    hash2[sprintf(key_fmt_str, key)] = sprintf(val_fmt_str, val)
  end
  hash2
end

def show_backgrounds()
  # show all the background colores and quit
  header
  puts
  puts "# Background Colors:"
  codes = normalize_widths(background_codes)
  codes.keys.each do |key|
    print "echo -e \"\\033[#{codes[key]}m"
    print "\033[#{codes[key]}m#{key}\033[0m"
    puts  "\\033[0m\""
  end    
end

def show_foregrounds(bg_color)
  bg_code = background_codes()[bg_color]
  style_codes = {
    dim:      '02',
    default:  '00',
    bold:     '01',
    italic:   '03',
    overline: '53',
    underline:'04',
    blink:    '05',
    reverse:  '07',
  }
  header
  puts
  puts "# Foreground Colors on \"#{bg_color}\":"
  codes = normalize_widths(foreground_codes)
  codes.keys.each do |key|
    style_codes.keys.each do |style|
      code=";#{style_codes[style]}"
      print "echo -e \"\\033[#{codes[key]};#{bg_code}#{code}m"
      print "\033[#{codes[key]};#{bg_code}#{code}m#{key}\033[0m"
      puts  "\\033[0m\" # #{style}"
    end
  end
end

if ARGV.size == 0
  show_backgrounds
  exit
end

if ARGV.size != 1
  usage
end

color=ARGV[0]

if ! background_codes().keys.include?(color)
  if background_codes().keys.include?("#{color}_background")
    color = "#{color}_background"
  else
    puts "ERROR: unrecognized color \"#{color}\"."
    puts "       please use one of:"
    background_codes().keys.each do |key|
      puts "         \"#{key}\""
    end
    abort
  end
end

show_foregrounds(color)
