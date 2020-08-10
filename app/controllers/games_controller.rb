require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = (0..10).map { ('A'..'Z').to_a.sample }
  end

  def score
    @answer = params[:answer].upcase
    @letters = params[:letters]
    @score = score_and_message[0]
    @message = score_and_message[1]
    binding.pry
  end

  def valid_english_word?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    word = JSON.parse(open(url).read)
    word["found"]
  end

  def included?(attempt, grid)
    attempt.chars.all? { |char| attempt.count(char) <= grid.count(char) }
  end

  def score_and_message
    if included?(@answer, @letters)
      if valid_english_word?(@answer)
        [@answer.length, "Congratulations! #{@answer} is a valid English word!"]
      else
        [0, "Sorry, but #{@answer} doesn't seem to be a valid English word..."]
      end
    else
      [0, "Sorry, but #{@answer} can't be built out of #{@letters}"]
    end
  end
end
