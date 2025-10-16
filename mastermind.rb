# Build a Mastermind game from the command line where you have 12 turns to guess the
# secret code, starting with you guessing the computer’s random code.

# Six colors: white, black, yellow, red, blue, green [WBYRUG]
# Four holes for the code.

class GameBoard
  attr_reader :secret, :current_round, :max_rounds, :colors

  def initialize
    @colors = %w[w b y r u g] # Shorthand for the six colors: white, black, yellow, red, blue, green
    @password_length = 4
    @secret = @password_length.times.map { @colors.sample }
    @current_round = 1
    @max_rounds = 12
    @round_record = []
  end

  def print_board
    return if @round_record == []

    @round_record.each do |record|
      puts "Round #{record[3]}   Guess: #{record[0]}   Correct: #{record[1]}   Right Color: #{record[2]}"
    end
  end

  def end_round
    @current_round += 1
  end

  def check_guess(guess)
    return player_wins if player_win?(guess)

    correct = get_results(guess)
    puts "You have #{correct[0]} colors in the right position"
    puts "You have #{correct[1]} colors in the wrong position"
    puts
    @round_record[@current_round - 1] = [guess, correct[0], correct[1], @current_round]
  end

  def get_results(guess)
    matches = get_matches(guess)
    stripped_guess = strip_matches(guess, matches)
    stripped_secret = strip_matches(@secret, matches)
    color_present = get_unmatched_colors(stripped_guess, stripped_secret)
    [matches.length, color_present.length]
  end

  def get_matches(guess)
    matches = []
    # Exact matches
    guess.each_with_index do |color, i|
      matches.push(i) if color == @secret[i]
    end
    matches
  end

  def get_unmatched_colors(stripped_guess, stripped_secret)
    stripped_guess.each_with_index.filter_map do |color, i|
      if (index = stripped_secret.index(color)) # Ruby will use the returned value for the check AND do the assignment (!)
        stripped_secret.delete_at(index)
        i
      end
    end
  end

  def strip_matches(to_strip, matches)
    to_strip.reject.with_index { |_, idx| matches.include?(idx) }
  end

  def player_win?(guess)
    guess == @secret
  end

  def player_wins
    @current_round = @max_rounds
    puts 'You guessed the secret!'
  end
end

def mastermind
  board = GameBoard.new
  while board.current_round <= board.max_rounds
    # get input

    guess = ask_for_player_input(board)

    puts
    puts "Computer key: #{board.secret}"
    puts "Your guess: #{guess}"
    puts
    board.check_guess(guess)
    break if board.player_win?(guess)

    board.print_board
    board.end_round
  end
  puts 'You did not guess the secret in time. You lose' unless board.player_win?(guess)
  puts 'The game is over.'
end

def ask_for_player_input(board)
  loop do
    puts 'Enter your guess of four colors by inputting the capital letter: White, Black, Yellow, Red, blUe, Green: '
    guess = gets.chomp.downcase.split('')

    error = validate_guess(guess, board)
    return guess unless error

    puts "#{error}\n"
  end
end

def validate_guess(guess, board)
  return 'Incorrect number of colors entered. Try again. Do not separate colors by spaces.' if guess.length != 4
  return 'Incorrect color entered. Only put in the color capitals. Try again' unless guess.all? do |color|
    board.colors.include?(color)
  end

  nil
end

mastermind
