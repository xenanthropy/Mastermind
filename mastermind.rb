# frozen_string_literal: true

# Main class that contains the main code of the
class Mastermind
  attr_reader :correct_answer

  def initialize(correct_answer)
    @correct_answer = correct_answer
  end

  def start
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

  def compare(guess, correct_answer)
    hint_hash = { red: 0, white: 0 }
    guess_array = guess.to_s.split('')
    correct_answer_array = correct_answer.to_s.split('')
    guess_array.each_with_index do |num, index|
      # puts "#{num} in guess_array"
      # puts "#{correct_answer_array[index]} in correct_answer_array"
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

  def winner(guess, turn_number)
    puts "Congratulations! #{guess} was the correct answer. It took you #{turn_number} guesses!"
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
end

bot = Computer.new
new_game = Mastermind.new(bot.guess)
new_game.start
