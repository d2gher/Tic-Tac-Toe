# frozen_string_literal: false
require 'io/console'

$stdout.clear_screen # or STDOUT.clear_screen

# Create a player class
class Player
  @@player_count = 0
  attr_accessor :name, :score, :symbol

  def initialize(name = 'player1', symbol)
    @name = name.capitalize
    @symbol = symbol.capitalize
    @score = 0
    @@player_count += 1
  end
end

def create_player
  puts "Player #{Player.class_variable_get(:@@player_count) + 1} name:"
  player_name = gets.chomp

  puts 'Pick a symbol:'
  player_symbol = gets.chomp

  Player.new(player_name, player_symbol)
end

player1 = create_player
player2 = create_player

while true
  print "
|=============================|
|======== TIC TAC TOE ========|
|=============================|

 1 | 2 | 3   | Score board
---+---+---  | #{player1.name} (#{player1.symbol}): #{player1.score}
 4 | 5 | 6   | #{player2.name} (#{player2.symbol}): #{player2.score}
---+---+---
 7 | 8 | 9   | CTRL + C to quit
 "
 puts "\n Choose where to play"

 gets
end
