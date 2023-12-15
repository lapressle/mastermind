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

  def initialize(farleft, left, right, _farright)
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
class Player
  attr_accessor :role

  def initialize(role)
    @role = role
  end
end
