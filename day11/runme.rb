def calculate_password(current_password)

  password = current_password
  until valid(password)
    password = password.next
  end

  password
end

def valid(password)
  return false if /[iol]/.match(password)

  return false unless match = /(.)\1{1,}/.match(password)
  return false unless /([^#{match.captures[0]}])\1{1,}/.match(password)

  return false unless set_of_increasing.select{ |required_sequence| password.include?(required_sequence) }.count == 1

  true
end

def set_of_increasing
  return @set_of_increasing if @set_of_increasing

  arr = []

  alphabet = ('a'..'z').to_a

  combination = nil
  count = 0
  until combination == "xyz"
    combination = alphabet.slice(count, 3).join ""
    arr << combination
    count += 1
  end

  @set_of_increasing = arr
end

def read_input
  if ARGV.length > 0
    ARGV[0]
  else
    STDIN.read
  end
end

puts "Santa's next password is: #{calculate_password(read_input)}"

