def nice?(line)
  return false if line.chars.reduce(0) { |total, character| total + (%w(a e i o u).include?(character) ? 1 : 0) } < 3
  return false unless /(.)\1{1,}/.match(line)
  return false if %w(ab cd pq xy).any?{ |illegal_sequence| line.include?(illegal_sequence) }

  true
end

def nice_v2?(line)
  return false unless /(.).\1{1}/.match(line)
  return false unless /(..).*\1{1}/.match(line)

  true
end

def number_of_nice_strings(input, new_rules)
  input.each_line.count {|line| new_rules ? nice_v2?(line) : nice?(line)}
end

def read_input
  if ARGV.length == 2 and ARGV[0]== "--with-new-rules"
    [File.read(ARGV[1]), true]
  elsif ARGV.length == 1 and ARGV[0]== "--with-new-rules"
    [STDIN.read, true]
  elsif ARGV.length > 0
    [File.read(ARGV[0]), false]
  else
    [STDIN.read, false]
  end
end

(data, use_new_rules) = read_input

puts "Number of nice strings: #{number_of_nice_strings(data, use_new_rules)}"
