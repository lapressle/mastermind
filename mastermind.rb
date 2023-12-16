# frozen_string_literal: true

# This defines the rules for the game
module GameRules
  def check_guess(starting_board, guess)
    guess_results = []
    guess_right?(starting_board, guess, guess_results)
    GameRow.new(guess_results)
  end

  def guess_right?(starting_board, guess, guess_results)
    starting_board.each_with_index do |color, position|
      if color == guess[position].to_i
        guess_results.push(color)
      elsif starting_board.any? { |color| color == guess[position].to_i }
        guess_results.push('0')
      else
        guess_results.push('x')
      end
    end
  end
end

# Actual actions for playing the game and winning
class Game
  def initialize; end
end

# This sets up the pieces of the board
class GameBoard
  attr_reader :starting_board, :player
  attr_accessor :guess_board

  def initialize(code_master, player)
    @starting_board = code_master.make_code
    @player = player
    @guess_board = []
  end

  def board_update(guess)
    guess_board.push(player.check_guess(starting_board, guess))
    guess_board
  end
end

# This is each row for the game made up of four pieces
class GameRow
  attr_reader :farleft, :left, :right, :farright

  def initialize(arr)
    @farleft = arr[0]
    @left = arr[1]
    @right = arr[2]
    @farright = arr[3]
  end
end

# These are the pieces for each row
class GamePieces
  attr_reader :position, :color

  def initialize(color, position)
    @color = color
    @position = position
  end
end

# Player and Computer classes
class Players
  attr_accessor :name, :role

  def initialize(name, role)
    @name = name
    @role = role
  end
end

# Give codebreaker class to make guesses
class CodeBreaker
  attr_accessor :guesses

  def initialize
    @guesses = []
  end

  include GameRules

  def guess
    p 'Pick colors for the four locations: '
    guess = gets.chomp
    guesses.push(guess.split(''))
    guess.split('')
  end
end

# Give codemaster role to generate initial configuration
class CodeMaster
  def initialize; end

  def make_code
    4.times.map { Random.rand(1..6) }
  end
end

computer = CodeMaster.new
player = CodeBreaker.new
game_board = GameBoard.new(computer, player)
p game_board.starting_board
game_board.board_update([1, 2, 3, 4])
p game_board.board_update([2, 2, 3, 4])
