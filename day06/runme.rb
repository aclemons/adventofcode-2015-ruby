def switch_lights(line, grid)
  return unless match = /^(turn on|turn off|toggle) (\d+),(\d+) through (\d+),(\d+)/.match(line)

  (action, startx, starty, endx, endy) = match.captures

  for i in startx..endx do
    for j in starty..endy do
      key = [i, j]
      case action
        when 'turn off'
          grid.delete key
        when 'turn on'
          grid[key] = true
        when 'toggle'
          if grid.has_key? key
            grid.delete key
          else
            grid[key] = true
          end
      end
    end
  end

end

def light_count(input)
  grid = {}

  input.each_line {|line| switch_lights(line, grid)}

  grid.size
end

def read_input
  if ARGV.length > 0
    File.read(ARGV[0])
  else
    STDIN.read
  end
end

puts "The number of burning lights is #{light_count(read_input)}"

