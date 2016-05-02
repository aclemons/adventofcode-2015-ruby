require 'byebug'

class Path
  attr_reader :from, :to, :distance

  def initialize(from: nil, to: nil, distance: nil)
    @from = from
    @to = to
    @distance = distance
  end

  def to_s
    "#{from} -> #{to} [#{distance}]"
  end
end

def parse_line(line)
  (route, distance) = line.split("=")
  (from, to) = route.split("to")
  Path.new(from: from.strip, to: to.strip, distance: distance.strip.to_i)
end

def read_input
  if ARGV.length > 0
    File.read(ARGV[0])
  else
    STDIN.read
  end
end

def valid_moves(route, paths)
  paths.select{ |path| route.empty? || path.from == route.last }.select{ |path| !route.include?(path.to) }
end

def copy(alternative)
  alternative.map{|node| node.to_s }
end

def route_distance(paths, route)
  route_queue = route.map{|node| node.to_s}

  sum = 0

  current_position = route_queue.shift
  until route_queue.empty?
    next_position = route_queue.shift

    path = paths.detect{|path| path.from == current_position && path.to == next_position }

    if path.nil?
      puts "INVALID PATH: #{current_position} -> #{next_position}"
      return nil
    end

    sum += path.distance

    current_position = next_position
  end

  sum
end

def make_move(paths, route, move)
  route << move.to
end

def maybe_try_later(paths, last_best, alternatives, new_alternative)
  unless alternatives.include?(new_alternative)

    dist = route_distance(paths, new_alternative)
    last_best_dist = last_best ? route_distance(paths, last_best) : nil

    if dist && (!last_best_dist || dist <= last_best_dist)
      alternatives << new_alternative
      puts "#{dist} : #{new_alternative.join('->')}"
    end

    alternatives.sort! { |a, b| b.length <=> a.length }
  end
end

def find_shortest_route(paths)
  nodes = paths.map{|path| path.from }
  nodes.concat paths.map{|path| path.to }
  nodes.uniq!

  alternatives = nodes.map{ |node| [node] }

  last_best = nil

  until alternatives.empty?

    alternative = alternatives.shift

    moves = valid_moves(alternative, paths)

    if moves.empty?
      if alternative.length == nodes.length
        total_distance = route_distance(paths, alternative)

        if !last_best || total_distance < route_distance(paths, last_best)
          last_best = alternative
        end
      else
        puts "STUCK IN: #{alternative.join('->')}"
      end
    else
      moves.each do |move|
        new_alternative = copy(alternative)

        make_move(paths, new_alternative, move)

        maybe_try_later(paths, last_best, alternatives, new_alternative)
      end
    end
  end

  last_best
end

paths = read_input.each_line.map{|line| parse_line(line) }
paths = paths.concat(paths.map{|path| Path.new(from: path.to, to: path.from, distance: path.distance) })

shortest_route = find_shortest_route(paths)
puts "Shortest route: #{route_distance(paths, shortest_route)} #{shortest_route.join('->')}"


#puts "The number of characters of code for string literals minus the number of characters in memory for the values of the strings is: #{compute_size(read_input)}"

