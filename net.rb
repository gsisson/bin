#!/usr/bin/env ruby

require_relative '../lib/net.rb'
require_relative '../lib/string_colorize.rb'

# This program uses the Net class, to change the network interface from wifi to ethernet,
# report the status of those two networks, and suggest changes to common proxy environment
# variables.

THIS_FILE=File.basename(__FILE__)

def usage
  puts "usage: #{THIS_FILE} [--verbose|-v]  wifi  [on|off] # turn the network on/off (or show status)"
  puts "       #{THIS_FILE} [--verbose|-v]  ether [on|off] # turn the network on/off (or show status)"
  puts "       #{THIS_FILE} [--verbose|-v]  toggle         # switch networks"
  puts "       #{THIS_FILE} [--verbose|-v]  proxy?         # show whether proxy vars are set"
  puts "       #{THIS_FILE} [--verbose|-v]  proxy          # output cmds to set proxy vars"
  puts "       #{THIS_FILE} [--verbose|-v] [status]        # show network status"
end

begin
  net = Net.new
  if ARGV[0] == '--verbose' || ARGV[0] == '-v'
    net.verbose(true) 
    ARGV.shift
  end  
  network   = nil
  operation = nil
  if ARGV[0]
    case ARGV[0].to_sym
    when :toggle, :status, :proxy, :proxy?
      operation = ARGV[0].to_sym
      ARGV.shift
    when :wifi, :wireless
      ARGV.shift
      network = :wifi
    when :ether, :ethernet
      ARGV.shift
      network = :ether
    end
  end
  if ARGV[0] && network
    operation =
      case ARGV[0].to_sym
      when :on, :up
        ARGV.shift
        :on
      when :off, :down, :dn
        ARGV.shift
        :off
      end
  end
  if   ARGV.size > 0 \
    || network   && ![:wifi, :ether                                 ].include?(network)  \
    || operation && ![:on,   :off, :status, :toggle, :proxy, :proxy?].include?(operation)
    usage
    exit 1
  end
  operation = :status if operation == nil && network == nil
  net.details(network)  if operation == nil && network
  net.status()          if operation == :status
  net.turn_on(network)  if operation == :on
  net.turn_off(network) if operation == :off
  net.toggle()          if operation == :toggle
  net.proxy_query()     if operation == :proxy?
  net.proxy_set()       if operation == :proxy
rescue SystemExit => e
  raise # re-raising passes the correct return code to the shell
rescue Interrupt => e
  puts "\nCancelled by user.".RED
rescue Exception => e
  puts "ERROR: Unexpected Exception:".RED
  puts "       (#{e.class}) #{e.message}"
  puts "       backtrace: "
  e.backtrace.each { |i| puts "      #{i}" }
  abort
end
