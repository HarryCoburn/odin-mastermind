# Build a Mastermind game from the command line where you have 12 turns to guess the
# secret code, starting with you guessing the computer’s random code.

# Six colors: white, black, yellow, red, blue, green [WBYRUG]
# Four holes for the code.

class GameBoard
  # Shorthand for the six colors: white, black, yellow, red, blue, green
  @@colors = %w[w b y r u g]

  attr_reader :secret, :current_round, :max_rounds

  def initialize
    @secret = 4.times.map { @@colors.sample }
    @current_round = 1
    @max_rounds = 12
    @round_record = {}
  end
end

def mastermind
  board = GameBoard.new
  puts 'Enter your guess of four colors by inputting the capital letter: White, Black, Yellow, Red, blUe, Green: '
  guess = gets.chomp.downcase.split('')
  puts "Computer key: #{board.secret}"
  puts "Your guess: #{guess}"
end

mastermind
