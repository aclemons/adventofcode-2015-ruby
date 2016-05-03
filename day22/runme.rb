#!/usr/bin/env ruby

SPELLS = [ "magic_missile", "drain", "shield", "poison", "recharge" ]

class Boss
  attr_accessor :poison_timer
  attr_reader :damage

  def initialize(hit_points, damage)
    @hit_points, @damage = hit_points, damage
    @poison_timer = 0
  end

  def turn(player)
    player.apply_spells

    return if player.dead?

    self.apply_spells

    return if dead?

    amount = [1, @damage - player.armour].max

    player.do_damage amount
  end

  def do_damage(amount)
    @hit_points -= amount
  end

  def apply_spells
    if @poison_timer > 0
      do_damage(3)

      @poison_timer -= 1
    end
  end

  def dead?
    @hit_points <= 0
  end
end

class Player

  attr_reader :armour, :spent_mana

  def initialize(hitpoints, mana, hard)
    @hit_points = hitpoints
    @mana = mana
    @spent_mana = 0
    @armour = 0
    @armour_timer = 0
    @recharge_timer = 0
    @hard = hard
  end

  def turn(boss)
    if @hard
      @hit_points -= 1
    end

    return if dead?

    self.apply_spells
    boss.apply_spells
  end

  def apply_spells
    return if dead?

    if @recharge_timer > 0
      @recharge_timer -= 1
      @mana += 101
    end

    if @armour_timer > 0
      @armour = 7
      @armour_timer -= 1
    end

    if @armour_timer <= 0
      @armour = 0
    end
  end

  def do_damage(amount)
    @hit_points -= amount
  end

  def cast_spell(spell, boss)
    case spell
    when "magic_missile"
      if @mana - 53 >= 0
        boss.do_damage(4)

        @mana -= 53
        @spent_mana += 53

        return true
      end

      return false
    when "drain"
      if @mana - 73 >= 0
        boss.do_damage(2)
        @hit_points += 2

        @mana -= 73
        @spent_mana += 73

        return true
      end

      return false
    when "shield"
      if @mana - 113 >= 0 and @armour <= 0
        @armour_timer = 6
        @mana -= 113
        @spent_mana += 113
        @armour = 7

        return true
      end

      return false
    when "poison"
      if @mana - 173 >= 0 and boss.poison_timer <= 0
        @mana -= 173
        @spent_mana += 173

        boss.poison_timer=(6)

        return true
      end

      return false
    when "recharge"

      if @mana - 229 >= 0 and @recharge_timer <= 0
        @mana -= 229
        @spent_mana += 229

        @recharge_timer = 5

        return true
      end

      return false
    end

    return false
  end

  def dead?
    @hit_points <= 0 or @mana <= 0
  end

end

def calculate_least_mana(boss_hit_points, boss_damage, hard)

  i = 1
  least_mana = -1
  winning_combination = nil
  until least_mana > 0
    SPELLS.repeated_permutation(i).each do |spells|

      boss = Boss.new(boss_hit_points, boss_damage)
      player = Player.new(50, 500, hard)

      try = spells.dup.reverse
      until boss.dead? or player.dead?
        player.turn(boss)

        break if player.dead?

        spell = spells.pop

        if spell.nil?
          break
        end

        if !player.cast_spell spell, boss
          break
        end

        boss.turn(player)
      end

      if boss.dead?
        if least_mana == -1 or player.spent_mana < least_mana
          least_mana = player.spent_mana
          winning_combination = try
        end
      end
    end

    i += 1
  end

  return least_mana, winning_combination
end

def read_input
  if ARGV.length == 2 and ARGV[0]== "--hard"
    [File.read(ARGV[1]), true]
  elsif ARGV.length == 1 and ARGV[0]== "--hard"
    [STDIN.read, true]
  elsif ARGV.length > 0
    [File.read(ARGV[0]), false]
  else
    [STDIN.read, false]
  end
end

def parse_input(data)
  vals = data.split("\n")

  hit_points = nil
  damage = nil

  vals.each do |str|
    (key, val) = str.split(":")

    key.strip!
    val.strip!

    if key == "Damage"
      damage = val.to_i
    else
      hit_points = val.to_i
    end
  end

  return hit_points, damage
end

(data, hard) = read_input
(least_mana, combination) = calculate_least_mana(*parse_input(data), hard)

puts "Least Mana Spent: #{least_mana} by playing #{combination.to_s}"
