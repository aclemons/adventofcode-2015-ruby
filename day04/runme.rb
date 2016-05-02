require 'digest'

def mine_advent_coin(secret, zero_count)
  i = 1

  until /^#{"0" * zero_count}/.match(Digest::MD5.hexdigest "#{secret}#{i}") do i += 1; end

  i
end

def read_input
  if ARGV.length == 2 and ARGV[0]== "--with-six-zeros"
    [ARGV[1], 6]
  elsif ARGV.length == 1 and ARGV[0]== "--with-six-zeros"
    [STDIN.read, 6]
  elsif ARGV.length > 0
    [ARGV[0], 5]
  else
    [STDIN.read, 5]
  end
end

(input_secret, required_zeros) = read_input
puts "The lowest number is #{mine_advent_coin(input_secret, required_zeros)}"

