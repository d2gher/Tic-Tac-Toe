# frozen_string_literal: false
require 'io/console'

$stdout.clear_screen # or STDOUT.clear_screen

# Create a player class
class Player
  @@player_count = 0
  attr_accessor :name, :score, :symbol

  def initialize(name, symbol)
    @name = name.capitalize
    @symbol = symbol[0].capitalize
    @score = 0
    @@player_count += 1

    if @symbol.to_i.is_a? Integer
      (@@player_count == 1)? @symbol = 'X': @symbol = 'O'
    end
    @symbol = symbol.capitalize
  end
end

def create_player
  puts "Player #{Player.class_variable_get(:@@player_count) + 1} name:"
  player_name = gets.chomp

  puts 'Pick a symbol:'
  player_symbol = gets.chomp

  Player.new(player_name, player_symbol)
end

def print_board(board, player1, player2)
  $stdout.clear_screen # or STDOUT.clear_screen
  print "
  |=============================|
  |======== TIC-TAC-TOE ========|
  |=============================|

   #{board[0]} | #{board[1]} | #{board[2]}   | Score board
  ---+---+---  | #{player1.name} (#{player1.symbol}): #{player1.score}
   #{board[3]} | #{board[4]} | #{board[5]}   | #{player2.name} (#{player2.symbol}): #{player2.score}
  ---+---+---
   #{board[6]} | #{board[7]} | #{board[8]}   | CTRL + C to quit
  "
end

def get_player_move(player, board, board_size)
  move = 0
  while move < 1 || move > board_size**2
    puts "\n #{player.name}'s turn! pick a number btween 1 and #{board_size**2}"
    move = gets.chomp.to_i
    move = 0 unless board[move - 1].is_a? Integer
  end
  move - 1
end

def play_a_round(board, board_size, player1, player2)
  print_board(board, player1, player2)
  while true
    move = get_player_move(player1, board, board_size)
    board[move] = player1.symbol
    print_board(board, player1, player2)

    move = get_player_move(player2, board, board_size)
    board[move] = player2.symbol
    print_board(board, player1, player2)
  end
end

player1 = create_player
player2 = create_player

board_size = 3
board = (1..(board_size * board_size)).to_a

play_a_round(board, board_size, player1, player2)
