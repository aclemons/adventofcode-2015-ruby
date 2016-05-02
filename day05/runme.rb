require 'byebug'

def nice?(line)
  return false if line.chars.reduce(0) { |total, character| total + (%w(a e i o u).include?(character) ? 1 : 0) } < 3
  return false unless /(.)\1{1,}/.match(line)
  return false if %w(ab cd pq xy).any?{ |illegal_sequence| line.include?(illegal_sequence) }

  true
end

def number_of_nice_strings(input)
  input.each_line.count {|line| nice?(line)}
end

def read_input
  if ARGV.length > 0
    File.read(ARGV[0])
  else
    STDIN.read
  end
end

puts "Number of nice strings: #{number_of_nice_strings(read_input)}"
