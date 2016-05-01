def calculate_move(coordinates, direction)
  new_coordinates = coordinates.clone

  case direction
    when '<'
      new_coordinates[0] -= 1
    when '>'
      new_coordinates[0] += 1
    when '^'
      new_coordinates[1] -= 1
    when 'v'
      new_coordinates[1] += 1
  end

  new_coordinates
end

def number_of_houses(input)
  input
      .chars
      .each_with_object([[0, 0]]) { |direction, coordinates| coordinates << calculate_move(coordinates.last, direction) }
      .uniq
      .count
end

def read_input
  if ARGV.length > 0
    File.read(ARGV[0])
  else
    STDIN.read
  end
end

puts "Only #{number_of_houses(read_input)} houses received presents"

