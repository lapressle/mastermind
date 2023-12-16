# frozen_string_literal: true

# This defines the rules for the game
module GameRules
  def check_guess(starting_board, guess)
    guess_results = []
    guess_right?(starting_board, guess, guess_results)
    current_row = GameRow.new(guess_results)
    "#{current_row.farleft} #{current_row.left} #{current_row.right} #{current_row.farright}"
  end

  def winner?(starting_board, guess)
    (starting_board <=> guess.map(&:to_i)).zero?
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
def run_game(player, game_board)
  p game_board.starting_board
  i = 0
  while i < 12
    guess = player.guess
    game_board.board_update(guess).each { |row| p row }
    return 'Congrats you won!' if player.winner?(game_board.starting_board, guess)

    i += 1
  end
  'Better luck next time!'
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
run_game(player, game_board)
