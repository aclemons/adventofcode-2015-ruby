def calculate_string(input)
  last = []
  results = input.chomp.chars.each_with_object([]) do |num, results|
    if !last.empty? and num != last.first
      results << last.length
      results << last.first

      last = []
    end

    last << num
  end

  if !last.empty?
    results << last.length
    results << last.first
  end

  results.join ""
end

def read_input
  if ARGV.length > 0
    ARGV[0]
  else
    STDIN.read
  end
end

input = read_input
1.upto(40) do |idx|
  input = calculate_string(input)
end

puts "Length of the result is #{input.length}"

