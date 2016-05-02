class Reindeer

  RUNNING = "running"
  RESTING = "resting"

  attr_reader :distance, :score

  def initialize(name, speed, sprint_time, resting_time)
    @name, @speed, @sprint_time, @resting_time = name, speed, sprint_time, resting_time
    @state = RUNNING
    @time_in_state = 0
    @distance = 0
    @score = 0
  end

  def run
    @time_in_state += 1

    case @state
    when RUNNING
      @distance += @speed

      if @time_in_state == @sprint_time
        @time_in_state = 0
        @state = RESTING
      end
    when RESTING
      if @time_in_state == @resting_time
        @time_in_state = 0
        @state = RUNNING
      end
    end
  end

  def add_point_to_score
    @score += 1
  end

  def to_s
    "Name: #{@name}, speed: #{@speed}, sprint_time: #{@sprint_time}, resting_time: #{@resting_time}, state: #{@state}, time_in_state: #{@time_in_state}, distance: #{@distance}, score: #{@score}"
  end

end

def parse_reindeer(line)
  return nil unless match = /^(.+) can fly (\d+) km\/s for (\d+) seconds, but then must rest for (\d+) seconds\.$/.match(line)

  Reindeer.new(match.captures[0], match.captures[1].to_i, match.captures[2].to_i, match.captures[3].to_i)
end

def run_race(input, time)
  reindeer = input.each_line.reduce([]) do |reindeer, line|
    line.chomp!

    deer = parse_reindeer(line)

    reindeer << deer unless deer.nil?

    reindeer
  end

  1.upto(time) do |i|
    reindeer.each do |deer|
      deer.run
    end

    reindeer.group_by(&:distance).max_by {|k,v| k}[1].each { |deer| deer.add_point_to_score }
  end

  reindeer
end

def read_input
  if ARGV.length > 0
    File.read(ARGV[0])
  else
    STDIN.read
  end
end

reindeer = run_race(read_input, 2503)

winner_by_distance = reindeer.max_by(&:distance)
winner_by_points = reindeer.max_by(&:score)

puts "Scored by distance, the winning reindeer travelled #{winner_by_distance.distance}"
puts "Scored by points, the winning reindeer has #{winner_by_points.score} points"
