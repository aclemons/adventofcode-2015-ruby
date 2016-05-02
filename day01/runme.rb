def calculate_floor(input)
  input.each_char.with_index.reduce([0, nil]) do |tuple, (character,index)|

    sum = tuple[0]

    if sum == -1 and tuple[1].nil?
      tuple[1] = index
    end

    tuple[0] = case character
      when '('
        1
      when ')'
        -1
      else
        0
    end + sum

    tuple
  end
end

def read_input
  if ARGV.length > 0
    File.read(ARGV[0])
  else
    STDIN.read
  end
end

(floor, basement_position) = calculate_floor(read_input)

puts "Santa should be on floor: #{floor} and first entered the basement at #{basement_position}"

