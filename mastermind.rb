# Build a Mastermind game from the command line where you have 12 turns to guess the
# secret code, starting with you guessing the computer’s random code.

# Six colors: white, black, yellow, red, blue, green [WBYRUG]
# Four holes for the code.

class GameBoard
  attr_reader :secret, :current_round, :max_rounds, :colors

  def initialize
    @colors = %w[w b y r u g] # Shorthand for the six colors: white, black, yellow, red, blue, green
    @secret = 4.times.map { @colors.sample }
    @current_round = 1
    @max_rounds = 12
    @round_record = {}
  end

  def end_round
    @current_round += 1
  end
end

def mastermind
  board = GameBoard.new
  while board.current_round <= board.max_rounds
    # get input
    puts "Current round: #{board.current_round}"
    guess = ask_for_player_input(board)

    puts "Computer key: #{board.secret}"
    puts "Your guess: #{guess}"
    puts
    board.end_round
  end
  puts 'The game is over.'
end

def ask_for_player_input(board)
  valid_input = false
  until valid_input
    puts 'Enter your guess of four colors by inputting the capital letter: White, Black, Yellow, Red, blUe, Green: '
    guess = gets.chomp.downcase.split('')
    if guess.length != 4
      puts 'Incorrect number of colors entered. Try again. Do not separate colors by spaces.'
      puts
      next
    elsif !guess.all? { |color| board.colors.include?(color) }
      puts 'Incorrect color entered. Only put in the color capitals. Try again'
      puts
      next
    else
      valid_input = true
    end
  end
  guess
end

mastermind
