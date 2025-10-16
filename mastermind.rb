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
    player_wins if guess == @secret
    correct = get_matches(guess)
    puts "You have #{correct[0]} colors in the right position"
    puts "You have #{correct[1]} colors in the wrong position"
    puts
    @round_record[@current_round - 1] = [guess, correct[0], correct[1], @current_round]
  end

  def get_matches(guess)
    matches = []
    color_present = []

    # Exact matches
    guess.each_with_index do |color, i|
      matches.push(i) if color == @secret[i]
    end

    stripped_guess = guess.reject.with_index { |_, idx| matches.include?(idx) }
    # puts "Stripped guess is: #{stripped_guess}"
    stripped_secret = @secret.reject.with_index { |_, idx| matches.include?(idx) }
    # puts "Stripped secret is: #{stripped_secret}"

    # Right color, wrong position
    stripped_guess.each_with_index do |color, i|
      if stripped_secret.include?(color)
        if stripped_secret.count(color) == 1
          color_present.push(i)
        else
          color_present.push(i)
          stripped_secret.delete_at(stripped_secret.index(color) || stripped_secret.length)
        end
      end
    end
    # puts "Present colors not matched are: #{color_present}"

    [matches.length, color_present.length]
  end

  def player_wins
    puts 'You win!'
  end
end

def mastermind
  board = GameBoard.new
  while board.current_round <= board.max_rounds
    # get input

    guess = ask_for_player_input(board)

    puts "Computer key: #{board.secret}"
    puts "Your guess: #{guess}"
    puts
    board.check_guess(guess)
    board.print_board
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
