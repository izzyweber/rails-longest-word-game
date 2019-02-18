require 'json'
require 'open-uri'

class GamesController < ApplicationController
  ALL_LETTERS = ("A".."Z").to_a

  def letters_legit?(attempt, grid)
    attempt_array = attempt.split("")
    legit_letters = []
    attempt_array.map do |letter|
      if grid.include?(letter.upcase)
        grid.delete_at(grid.index(letter.upcase))
        legit_letters << letter
      end
    end
    attempt_array.length == legit_letters.length
  end

  def word_english?(attempt)
    response = open("https://wagon-dictionary.herokuapp.com/#{attempt}").read
    JSON.parse(response)['found']
  end

  def run_game(attempt, grid)
    results = { score: 0 }
    if !letters_legit?(attempt, grid)
      results[:message] = "Those letters aren't in your grid! Try again."
    elsif !word_english?(attempt)
      results[:message] = "That's not an English word! Try again."
    else
      results[:message] = 'Well done!'
      results[:score] = attempt.length
    end
    results
  end

  def calc_score(word, array)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    words = JSON.parse(open(url).read)
    run_game(word, array)
  end

  def new
    @letters = []
    10.times { @letters << ALL_LETTERS.sample }
    @letters
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    @response = calc_score(@word, @letters.split(""))
    session[:current_user_session] += @response[:score]
  end
end
