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
  game_board.starting_board
  i = 0
  while i < 12
    guess = player.guess
    game_board.board_update(guess).each { |row| p row }
    return 'Congrats you won!' if player.winner?(game_board.starting_board, guess)

    i += 1
  end
  'Better luck next time!'
end

def run_computer_game(computer, game_board)
  game_board.starting_board
  i = 0
  while i < 12
    guess = computer.computer_guess
    game_board.board_update(guess).each { |row| p row }
    return 'The computer cracked it!' if computer.winner?(game_board.starting_board, guess)

    i += 1
  end
  'You won!'
end

def pick_role
  p 'Would you like to be code master? (y/n)'
  choice = gets.chomp
  until %w[y n].include?(choice)
    p 'Must pick y or n'
    choice = gets.chomp
  end
  choice
end

# This sets up the pieces of the board
class GameBoard
  attr_reader :starting_board, :code_breaker
  attr_accessor :guess_board

  def initialize(code, code_breaker)
    @starting_board = code
    @code_breaker = code_breaker
    @guess_board = []
  end

  def board_update(guess)
    guess_board.push(code_breaker.check_guess(starting_board, guess))
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
    until guess.length <= 4 && guess.to_i != 0
      p 'Please try again'
      guess = gets.chomp
    end
    guesses.push(guess.split(''))
    guess.split('')
  end

  def computer_guess
    guess = 4.times.map { Random.rand(1..6) }
    guesses.push(guess)
    p guess
  end
end

# Give codemaster role to generate initial configuration
class CodeMaster
  def initialize; end

  def make_code
    4.times.map { Random.rand(1..6) }
  end

  def player_code
    p 'Pick colors for the four locations: '
    code = gets.chomp
    until code.length <= 4 && code.to_i != 0
      p 'Please try again'
      code = gets.chomp
    end
    code = code.split('')
    code.map(&:to_i)
  end
end

choice = pick_role
if choice == 'y'
  player = CodeMaster.new
  computer = CodeBreaker.new
  game_board = GameBoard.new(player.player_code, computer)
  run_computer_game(computer, game_board)
elsif choice == 'n'
  computer = CodeMaster.new
  player = CodeBreaker.new
  game_board = GameBoard.new(computer.make_code, player)
  run_game(player, game_board)
end
