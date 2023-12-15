# frozen_string_literal: true

# This defines the rules for the game
class GameRules
end

# This sets up the pieces of the board
class GameBoard
end

# This is each row for the game made up of four pieces
class GameRow
  attr_reader :farleft, :left, :right, :farright

  def initialize(farleft, left, right, farright)
    @farleft = farleft
    @left = left
    @right = right
    @farright = farright
  end
end

# These are the pieces for each row
class GamePieces
  attr_reader :position, :color

  def initialize(position, color)
    @position = position
    @color = color
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
  def guess
    p 'Pick colors for the four locations: '
    gets.chomp
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
p computer.make_code
