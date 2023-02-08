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

def check_if_winner(board, board_size)
  # Horizontal check
  h = 0
  while h < board.length
    winner = true
    (board_size - 1).times do |i|
      current_pos = h + i
      next_pos = current_pos + 1
      winner = false unless board[current_pos] == board[next_pos]
    end
    return true if winner
    h += board_size
  end

  # Vertical check
  v = 0
  while v < board_size
    winner = true
    current_pos = v
    (board_size - 1).times do |i|
      next_pos = current_pos + board_size
      winner = false unless board[current_pos] == board[next_pos]
      current_pos = next_pos
    end
    return true if winner
    v += 1
  end

  # Cross check
  winner = true
  current_pos = 0
  (board_size - 1).times do
    next_pos = current_pos + board_size + 1
    winner = false unless board[current_pos] == board[next_pos]
    current_pos = next_pos
  end
  return true if winner
  
  winner = true
  current_pos = board_size - 1
  (board_size - 1).times do
  next_pos = current_pos + board_size - 1
  winner = false unless board[current_pos] == board[next_pos]
  current_pos = next_pos
  end
  return true if winner

  return false
end

def print_winner(message)
  print "
  |=============================|
   #{message}
  |=============================|
  "
end

def draw?(board)
  board.all? {|e| e.is_a? String }
end

def play_a_round(board, board_size, player1, player2)
  print_board(board, player1, player2)
  while true
    move = get_player_move(player1, board, board_size)
    board[move] = player1.symbol
    print_board(board, player1, player2)
    if check_if_winner(board, board_size)
      print_winner("#{player1.name} has won!")
      player1.score += 1
      break
    end
    if draw?(board)
      print_winner("It's a draw!")
      break
    end
    move = get_player_move(player2, board, board_size)
    board[move] = player2.symbol
    print_board(board, player1, player2)
    if check_if_winner(board, board_size)
      print_winner("#{player2.name} has won!")
      player2.score += 1
      break
    end
    if draw?(board)
      print_winner("It's a draw!")
      break
    end
  end
end

player1 = create_player
player2 = create_player

board_size = 3
board = (1..(board_size * board_size)).to_a

play_a_round(board, board_size, player1, player2)

while true
  puts "\n Wanna play another round? press 'Y'"
  prompt = STDIN.gets.chomp
  break unless prompt == "y" || prompt == "Y"
  board = (1..(board_size * board_size)).to_a
  play_a_round(board, board_size, player1, player2)
end
