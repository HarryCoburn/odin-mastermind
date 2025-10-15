# Build a Mastermind game from the command line where you have 12 turns to guess the
# secret code, starting with you guessing the computer’s random code.

# Six colors: white, black, yellow, red, blue, green [WBYRUG]
# Four holes for the code.

class GameBoard
  # Shorthand for the six colors: white, black, yellow, red, blue, green
  @@colors = %w[w b y r u g]

  attr_reader :secret

  def initialize
    @secret = 4.times.map { @@colors.sample }
  end
end

board = GameBoard.new
puts board.secret
