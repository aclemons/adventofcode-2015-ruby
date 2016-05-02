def calculate_floor(input)
  input.chars.reduce(0) do |sum, character|
    case character
      when '('
        1
      when ')'
        -1
      else
        0
    end + sum
  end
end

def read_input
  if ARGV.length > 0
    File.read(ARGV[0])
  else
    STDIN.read
  end
end

puts "Santa should be on floor: #{calculate_floor(read_input)}"
