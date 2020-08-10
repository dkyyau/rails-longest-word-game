require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = (0..10).map { ('A'..'Z').to_a.sample }
  end

  def score
    @answer = params[:answer].upcase
    @letters = params[:letters]
    @message = message
  end

  def valid_english_word?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    word = JSON.parse(open(url).read)
    word["found"]
  end

  def included?(attempt, grid)
    attempt.chars.all? { |char| attempt.count(char) <= grid.count(char) }
  end

  def message
    if included?(@answer, @letters)
      if valid_english_word?(@answer)
        "Congratulations! #{@answer} is a valid English word!"
      else
        "Sorry, but #{@answer} doesn't seem to be a valid English word..."
      end
    else
      "Sorry, but #{@answer} can't be built out of #{@letters}"
    end
  end
end
