def switch_lights(line, grid, new_translation)
  return unless match = /^(turn on|turn off|toggle) (\d+),(\d+) through (\d+),(\d+)/.match(line)

  (action, startx, starty, endx, endy) = match.captures

  for i in startx..endx do
    for j in starty..endy do
      key = [i, j]
      case action
        when 'turn off'
          if new_translation
            grid[key] ||= 0
            grid[key] -= 1
            grid.delete(key) if grid[key] <= 0
          else
            grid.delete key
          end
        when 'turn on'
          if new_translation
            grid[key] ||= 0
            grid[key] += 1
          else
            grid[key] = 1
          end
        when 'toggle'
          if new_translation
            grid[key] ||= 0
            grid[key] += 2
          else
            if grid.has_key? key
              grid.delete key
            else
              grid[key] = 1
            end
          end
      end
    end
  end
end


def light_count(input, new_translation)
  grid = {}

  input.each_line {|line| switch_lights(line, grid, new_translation)}

  grid.values.reduce(:+)
end

def read_input
  if ARGV.length == 2 and ARGV[0]== "--with-new-translation"
    [File.read(ARGV[1]), true]
  elsif ARGV.length == 1 and ARGV[0]== "--with-new-translation"
    [STDIN.read, true]
  elsif ARGV.length > 0
    [File.read(ARGV[0]), false]
  else
    [STDIN.read, false]
  end
end

(data, use_new_translation) = read_input

puts "The number of burning lights is #{light_count(data, use_new_translation)}"

