require 'digest'

def mine_advent_coin(secret)
  i = 1

  until /^00000/.match(Digest::MD5.hexdigest "#{secret}#{i}") do i += 1; end

  i
end

def read_input
  if ARGV.length > 0
    ARGV[0]
  else
    STDIN.read
  end
end

puts "The lowest number is #{mine_advent_coin(read_input)}"

