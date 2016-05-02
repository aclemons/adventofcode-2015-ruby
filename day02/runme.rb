def calculate_amount(input)
  input.each_line.reduce([0, 0]) do |sums, line|
    (l, w, h) = dimensions = line.split('x').map {|m| m.to_i}

    total_area = ([l * w, w * h, h * l].reduce(:+) * 2)
    slack = dimensions.sort.take(2).reduce(:*)

    length_of_present_ribbon = (dimensions.sort.take(2).reduce(:+) * 2)
    length_of_bow = dimensions.reduce(:*)

    [total_area + slack, length_of_present_ribbon + length_of_bow]

    sums[0] += total_area + slack
    sums[1] += length_of_present_ribbon + length_of_bow

    sums
  end

end

def read_input
  if ARGV.length > 0
    File.read(ARGV[0])
  else
    STDIN.read
  end
end

(paper, ribbon) = calculate_amount(read_input)

puts "The elves should order #{paper} sq ft of paper and #{ribbon} ft of ribbon "

