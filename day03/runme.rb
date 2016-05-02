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

def number_of_houses(input, robo_santa)
  santa_coordinates = [[0, 0]]
  robo_santa_coordinates = [[0, 0]]
  input.each_char.with_index do |direction, index|
    target = (robo_santa && index % 2 == 0) ? robo_santa_coordinates : santa_coordinates
    target << calculate_move(target.last, direction)
  end

  (santa_coordinates + robo_santa_coordinates).uniq.count
end

def read_input
  if ARGV.length == 2 and ARGV[0]== "--with-robo-santa"
    [File.read(ARGV[1]), true]
  elsif ARGV.length == 1 and ARGV[0]== "--with-robo-santa"
    [STDIN.read, true]
  elsif ARGV.length > 0
    [File.read(ARGV[0]), false]
  else
    [STDIN.read, false]
  end
end

(input, use_robo_santa) = read_input
puts "Only #{number_of_houses(input, use_robo_santa)} houses received presents"

