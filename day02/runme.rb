def calculate_amount(input)
  input.each_line.map do |line|
    (l, w, h) = dimensions = line.split('x').map {|m| m.to_i}

    total_area = ([l * w, w * h, h * l].reduce(:+) * 2)
    slack = dimensions.sort.take(2).reduce(:*)

    total_area + slack
  end.reduce(:+)
end

def read_input
  if ARGV.length > 0
    File.read(ARGV[0])
  else
    STDIN.read
  end
end

puts "The elves should order #{calculate_amount(read_input)} sq ft of paper"

