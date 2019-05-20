require 'open-uri'

class GamesController < ApplicationController
  def new
    # array of 10 random leters
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @guess = params[:guess]
    @grid = params[:letters]
    is_included = included?(@guess, @grid)
    is_english = english_word?(@guess)

    if is_english && is_included
      @final_message = "Congratulations! #{@guess.capitalize} is a valid english word."
      @result = result(@guess)
      @result_message = "Your score is #{@result}"
    elsif is_included && !is_english
      @final_message = "Sorry, #{@guess} doesn't seem to be an english word."
    elsif is english && !is_included
      @final_message = "Sorry, #{@guess} can't be built from the given letter."
    else
      @final_message = "Your guess is abosolute rubbish."
    end
  end

  def included?(guess, grid)
    guess.upcase.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
    raise
  end

  def english_word?(guess)
    response = open("https://wagon-dictionary.herokuapp.com/#{guess}")
    json = JSON.parse(response.read)
    return json['found']
  end

  def result(guess)
    return guess.length * 2
  end
end

  # def run_game(attempt, grid, start_time, end_time)
  #   result = { time: end_time - start_time }

  #   score_and_message = score_and_message(attempt, grid, result[:time])
  #   result[:score] = score_and_message.first
  #   result[:message] = score_and_message.last

  #   result
  # end

  # def compute_score(attempt, time_taken)
  #   time_taken > 60.0 ? 0 : attempt.size * (1.0 - time_taken / 60.0)
  # end
