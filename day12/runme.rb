require 'json'

def compute_sum(input)
  JSON.parse(input).reduce(0) { |sum, (key, value)| sum + sum_json(value) }
end

def sum_json(node)
  if node.is_a? Numeric
    node
  elsif node.is_a? Array
    node.map { |val| sum_json(val)}.reduce(:+)
  elsif node.is_a? Hash
    node.map { |key, val| sum_json(val) }.reduce(:+)
  else
    0
  end
end

def read_input
  if ARGV.length > 0
    File.read(ARGV[0])
  else
    STDIN.read
  end
end

puts "The sum of all numbers in the document is: #{compute_sum(read_input)}"

