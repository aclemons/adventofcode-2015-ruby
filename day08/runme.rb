#!/usr/bin/env ruby

def compute_size(input)
  input.each_line.map do |line|
    line.chomp!

    line.length - unescape(line).length
  end.reduce(:+)
end

def unescape(line)
  unquoted = line.slice(1..(line.length - 2))
  (eval %Q{"#{unquoted}"})
end

def read_input
  if ARGV.length > 0
    File.read(ARGV[0])
  else
    STDIN.read
  end
end

puts "The number of characters of code for string literals minus the number of characters in memory for the values of the strings is: #{compute_size(read_input)}"

