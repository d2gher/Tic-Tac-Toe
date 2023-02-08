# frozen_string_literal: false
require 'io/console'

def clear_console
  $stdout.clear_screen # or STDOUT.clear_screen
end

# Create a player class
class Player
  @@count = 0
  attr_accessor :name, :score, :symbol

  def initialize(name)
    @name = name.capitalize
    @symbol = @@count == 1 ? 'X' : 'O'
    @score = 0
    @@count += 1
  end
end

def create_player
  puts "Player #{Player.class_variable_get(:@@count) + 1} name:"
  player_name = gets.chomp
  Player.new(player_name)
end

def print_board(board, player1, player2)
  clear_console
  puts "
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
    # Make sure this postion hasn't been played
    move = 0 unless board[move - 1].is_a? Integer
  end
  move - 1
end

def horizontal_win?(board, board_size)
  row_start = 0
  while row_start < board.length
    winner = true
    current_pos = row_start
    (board_size - 1).times do
      next_pos = current_pos + 1
      winner = false unless board[current_pos] == board[next_pos]
      current_pos = next_pos
    end
    return true if winner
    row_start += board_size
  end
end

def vertical_win?(board, board_size)
  column_start = 0
  while column_start < board_size
    winner = true
    current_pos = column_start
    (board_size - 1).times do
      next_pos = current_pos + board_size
      winner = false unless board[current_pos] == board[next_pos]
      current_pos = next_pos
    end
    return true if winner

    column_start += 1
  end
end

def left_cross_win?(board, board_size)
  winner = true
  current_pos = 0

  (board_size - 1).times do
    next_pos = current_pos + board_size + 1
    winner = false unless board[current_pos] == board[next_pos]
    current_pos = next_pos
  end
  return true if winner
end

def right_cross_win?(board, board_size)
  winner = true
  current_pos = board_size - 1
  (board_size - 1).times do
    next_pos = current_pos + board_size - 1
    winner = false unless board[current_pos] == board[next_pos]
    current_pos = next_pos
  end
  return true if winner
end

def check_if_winner?(board, board_size)
  return true if horizontal_win?(board, board_size)
  return true if vertical_win?(board, board_size)
  return true if left_cross_win?(board, board_size)
  return true if right_cross_win?(board, board_size)
end

def draw?(board)
  board.all? { |e| e.is_a? String }
end

def print_winner(message)
  print "
  |=============================|
   #{message}
  |=============================|
  "
end

def play_a_round(board, board_size, player1, player2)
  print_board(board, player1, player2)
  loop do
    move = get_player_move(player1, board, board_size)
    board[move] = player1.symbol
    print_board(board, player1, player2)
    if check_if_winner?(board, board_size)
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
    if check_if_winner?(board, board_size)
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

loop do
  puts "\n Wanna play another round? Enter 'Y'"
  prompt = $stdin.gets.chomp
  break unless %w[y Y].include?(prompt)

  board = (1..(board_size * board_size)).to_a
  play_a_round(board, board_size, player1, player2)
end
