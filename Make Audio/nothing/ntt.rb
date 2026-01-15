#!/usr/bin/env ruby

# --- 1. Base Entity Class ---
class Entity
  attr_accessor :name, :hp, :max_hp, :attack_power

  def initialize(name, max_hp, attack_power)
    @name = name
    @max_hp = max_hp
    @hp = max_hp
    @attack_power = attack_power
  end

  def alive?
    @hp > 0
  end

  def take_damage(amount)
    @hp -= amount
    puts "#{@name} takes #{amount} damage! (HP: #{@hp}/#{@max_hp})"
  end

  def attack(target)
    # Random variance in damage (0.8x to 1.2x)
    variance = rand(0.8..1.2)
    damage = (@attack_power * variance).to_i
    puts "#{@name} attacks #{target.name} for #{damage} damage!"
    target.take_damage(damage)
  end
end

# --- 2. Player Class ---
class Player < Entity
  attr_accessor :potions, :gold

  def initialize(name)
    super(name, 100, 15) # Start with 100 HP, 15 ATK
    @potions = 2
    @gold = 0
  end

  def heal
    if @potions > 0
      heal_amount = 30
      @hp = [@hp + heal_amount, @max_hp].min
      @potions -= 1
      puts "You drank a potion. HP restored to #{@hp}/#{@max_hp}. Potions left: #{@potions}"
    else
      puts "You have no potions left!"
    end
  end

  def status
    puts "\n--- STATUS ---"
    puts "#{@name} | HP: #{@hp}/#{@max_hp} | Potions: #{@potions} | Gold: #{@gold}"
    puts "--------------"
  end
end

# --- 3. Room Generation ---
class Room
  attr_reader :description, :enemy, :loot_gold

  def initialize(description, has_enemy: false)
    @description = description
    if has_enemy
      # Generate random enemy
      names = ["Goblin", "Skeleton", "Orc", "Slime"]
      @enemy = Entity.new(names.sample, rand(30..60), rand(5..12))
      @loot_gold = rand(10..50)
    else
      @enemy = nil
      @loot_gold = rand(0..20)
    end
  end

  def enter(player)
    puts "\n" + "="*40
    puts "You enter #{@description}"
    
    if @enemy && @enemy.alive?
      puts "A wild #{@enemy.name} appears!"
      combat_loop(player)
    else
      puts "The room is quiet."
    end
    
    # Looting phase
    if player.alive?
      if @loot_gold > 0
        puts "You found #{@loot_gold} gold pieces!"
        player.gold += @loot_gold
        @loot_gold = 0 # Loot taken
      end
      
      # 30% chance to find a potion
      if rand < 0.3
        puts "You found a potion hidden in the corner!"
        player.potions += 1
      end
    end
  end

  def combat_loop(player)
    while player.alive? && @enemy.alive?
      puts "\nYour Action: (a)ttack, (h)eal, (r)un?"
      print "> "
      choice = gets.chomp.downcase

      case choice
      when 'a'
        player.attack(@enemy)
        @enemy.attack(player) if @enemy.alive?
      when 'h'
        player.heal
        @enemy.attack(player)
      when 'r'
        puts "You ran away safely!"
        return # Exit combat
      else
        puts "Invalid command. The enemy takes a free hit!"
        @enemy.attack(player)
      end
    end

    if player.alive?
      puts "You defeated the #{@enemy.name}!"
    else
      puts "You have been defeated..."
    end
  end
end

# --- 4. Game Engine ---
class Game
  def initialize
    @rooms = []
    puts "Welcome to the Ruby Spire."
    print "Enter your hero's name: "
    name = gets.chomp
    @player = Player.new(name.empty? ? "Hero" : name)
    generate_dungeon
  end

  def generate_dungeon
    # Procedurally generate 5 rooms
    descriptions = [
      "a dark, damp cave.",
      "an old library covered in cobwebs.",
      "a grand hall with flickering torches.",
      "a narrow stone corridor.",
      "an underground garden with glowing mushrooms."
    ]
    
    descriptions.each do |desc|
      # 70% chance of enemy in a room
      @rooms << Room.new(desc, has_enemy: rand < 0.7)
    end
    
    # Add final boss room manually
    boss_room = Room.new("the Throne Room of the Ruby King.", has_enemy: false)
    # Manually inject a boss
    boss = Entity.new("Ruby King", 150, 20)
    boss_room.instance_variable_set(:@enemy, boss)
    boss_room.instance_variable_set(:@loot_gold, 500)
    @rooms << boss_room
  end

  def start
    @rooms.each_with_index do |room, index|
      break unless @player.alive?
      
      puts "\nLevel #{index + 1}"
      @player.status
      
      puts "Press Enter to advance..."
      gets
      
      room.enter(@player)
    end

    game_over
  end

  def game_over
    puts "\n" + "*"*40
    if @player.alive?
      puts "CONGRATULATIONS!"
      puts "You cleared the dungeon with #{@player.gold} gold."
    else
      puts "GAME OVER"
      puts "Better luck next time."
    end
    puts "*"*40
  end
end

# --- Main Execution ---
if __FILE__ == $0
  game = Game.new
  game.start
end
