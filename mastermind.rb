# frozen_string_literal: true

# Main class that contains the main code of the
class Mastermind
  attr_reader :correct_answer, :codebreaker
  attr_accessor :total_guesses

  def initialize(correct_answer, codebreaker)
    @correct_answer = correct_answer
    @codebreaker = codebreaker
    self.total_guesses = []
  end

  def start_user
    guesses = []
    puts 'Computer has chosen a code. Time to break it, stinky!'
    (1..12).each do |turn_number|
      puts "Guess ##{turn_number}: "
      guess = gets.chomp.to_i
      until guess >= 1111 && guess <= 6666 && !guesses.include?(guess)
        puts 'Please input a number between 1111 and 6666 (and no numbers already guessed)'
        guess = gets.chomp.to_i
      end
      guesses.push(guess)
      hint_hash = compare(guess, correct_answer)
      if hint_hash[:red] == 4
        winner(guess, turn_number)
        break
      else
        p hint_hash
      end
    end
  end

  def start_computer
    self.total_guesses = Computer.all_guesses
    (1..12).each do |turn_number|
      puts "Guess ##{turn_number}: "
      sleep(3)
      guess = if turn_number == 1
                1122
              else
                total_guesses.sample
              end
      hint_hash = compare_computer(guess, correct_answer)
      slow_type(guess)
      if hint_hash[:red] == 4
        winner(correct_answer, turn_number)
        break
      else
        p hint_hash
        sleep(1)
      end
    end
  end

  def compare(guess, correct_answer)
    hint_hash = { red: 0, white: 0 }
    guess_array = guess.to_s.split('')
    correct_answer_array = correct_answer.to_s.split('')
    guess_array.each_with_index do |num, index|
      if num == correct_answer_array[index]
        hint_hash[:red] += 1
        correct_answer_array[index] = 'C'
        guess_array[index] == 'X'
      end
    end
    guess_array.each do |num2|
      if correct_answer_array.include?(num2)
        hint_hash[:white] += 1
        correct_answer_array[correct_answer_array.index(num2)] = 'C'
      end
    end
    hint_hash
  end

  def compare_computer(guess, correct_answer)
    current_hash = compare(guess, correct_answer)
    new_guesses = total_guesses.select do |value|
      compare(guess, value) == current_hash
    end
    self.total_guesses = new_guesses
    current_hash
  end

  def slow_type(guess)
    guess_array = guess.to_s.split('')
    guess_array.each do |value|
      print value.to_i
      sleep(0.35)
    end
    puts ''
  end

  def winner(guess, turn_number)
    if codebreaker == 'user'
      puts "Congratulations! #{guess} was the correct answer. It took you #{turn_number} guesses!"
    else
      puts "#{guess} was the correct answer. The computer took #{turn_number} guesses!"
    end
  end
end

# Computer class that picks a random code to be guessed
class Computer
  attr_accessor :codes

  def initialize
    self.codes = []
  end

  def guess
    (1111..6666).each do |num|
      codes.push(num)
    end
    codes.sample
  end

  def self.all_guesses
    codes = []
    (1111..6666).each do |num|
      codes.push(num)
    end
    codes
  end
end

bot = Computer.new
puts 'Who do you want to be the codebreaker: User or Computer?'
player_input = gets.chomp
until player_input.downcase == 'user' || player_input.downcase == 'computer'
  put 'please input either "user" or "computer"'
  player_input = gets.chomp
end
new_game = if player_input.downcase == 'user'
             Mastermind.new(bot.guess, 'user')
           else
             puts 'Enter a number between 1111 and 6666'
             player_number = gets.chomp.to_i
             until player_number >= 1111 && player_number <= 6666
               puts 'please only enter a number between 1111 and 6666'
               player_number = gets.chomp.to_i
             end
             Mastermind.new(player_number, 'computer')
           end
player_input == 'user' ? new_game.start_user : new_game.start_computer
