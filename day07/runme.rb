require 'byebug'

class Instruction
  attr_reader :param1, :param2, :operation, :result

  def initialize(param1: nil, param2: nil, operation: nil, result: nil)
    @param1 = param1
    @param2 = param2
    @operation = operation
    @result = result
  end

  def to_s
    "#{param1} #{operation} #{param2} -> #{result}"
  end
end

class Interpreter
  def initialize(input)
    @input = input
  end

  def call
    instructions = @input.each_line.map{|line| collect_ops(line) }
    process_instructions(instructions)
  end

  private

  def literal?(param)
    Integer(param) rescue nil
  end

  def value_of(variables, param)
    if literal?(param)
      Integer(param)
    else
      variables[param]
    end
  end

  def store_result(variables, param, value)
    variables[param] = value
  end

  def run_instruction(variables, instruction)
    val1 = value_of(variables, instruction.param1)
    val2 = value_of(variables, instruction.param2)

    variables[instruction.result] = case instruction.operation.downcase.to_sym
                                      when :lshift
                                        val1 << val2
                                      when :rshift
                                        val1 >> val2
                                      when :and
                                        val1 & val2
                                      when :or
                                        val1 | val2
                                      when :not
                                        ~(val1 || val2)
                                      when :assign
                                        (val1 || val2)
                                      else
                                        raise "Unknown instruction #{instruction.operation}"
                                    end
  end

  def can_run?(variables, instruction)
    (!instruction.param1 || literal?(instruction.param1) || variables.key?(instruction.param1)) &&
        (!instruction.param2 || literal?(instruction.param2) || variables.key?(instruction.param2))
  end

  def process_instructions(instructions)
    variables = {}

    until instructions.empty?
      instruction = instructions.shift

      if can_run?(variables, instruction)
        run_instruction(variables, instruction)
      else
        instructions << instruction
      end
    end

    variables
  end

  def collect_ops(line)
    if match = /^(.+) (LSHIFT|RSHIFT) (\d+) -> (.+)/.match(line)
      Instruction.new(param1: match.captures[0], param2: match.captures[2], operation: match.captures[1], result: match.captures[3])
    elsif match = /^(.+) (OR|AND) (.+) -> (.+)/.match(line)
      Instruction.new(param1: match.captures[0], param2: match.captures[2], operation: match.captures[1], result: match.captures[3])
    elsif match = /^(NOT) (.+) -> (.+)/.match(line)
      Instruction.new(param1: match.captures[1], param2: nil, operation: match.captures[0], result: match.captures[2])
    elsif match = /^(.+) -> (.+)/.match(line)
      Instruction.new(param1: match.captures[0], param2: nil, operation: 'assign', result: match.captures[1])
    end
  end
end

def read_input
  if ARGV.length > 0
    File.read(ARGV[0])
  else
    STDIN.read
  end
end

variables = Interpreter.new(read_input).call

puts "The signal for a is: #{variables['a']}"
