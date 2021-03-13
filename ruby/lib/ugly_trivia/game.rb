require 'pry'
require_relative './game_utils'
require_relative './player'

module UglyTrivia
  class Game
    attr_accessor :players, :places, :purses, :in_penalty_box,
                  :current_player, :is_getting_out_of_penalty_box, :players2
    PLACES = 11

    def initialize
      @players = []
      @current_player = 0
      @questions = GameUtils.generate_questions
    end

    def is_playable?
      players.length >= 2
    end

    def add_player(name)
      if players.size == 6
        puts "Max 6 players allowed, not adding new player."
        return false
      end

      players.push(Player.new(name))
      puts "#{name} was added"
      puts "They are player number #{players.length}"

      true
    end

    def roll(result)
      puts "#{cur_play.name} is the current player"
      puts "They have rolled a #{result}"

      return if remains_in_penalty_box(result)

      new_place(result)
      puts "The category is #{current_category}"
      ask_question
    end

    def remains_in_penalty_box(result)
      return false unless cur_play.in_penalty_box

      if result % 2 == 0
        puts "#{cur_play.name} is not getting out of the penalty box"
        true
      else
        cur_play.in_penalty_box = false
        puts "#{cur_play.name} is getting out of the penalty box"
        false
      end
    end

    def correct_answer
      if cur_play.in_penalty_box
        next_player
        return true
      end

      puts 'Answer was correct!!!!'
      cur_play.purse += 1
      puts "#{cur_play.name} now has #{cur_play.purse} Gold Coins."
      winner = did_player_win
      next_player
      winner
    end

    def wrong_answer
      puts 'Question was incorrectly answered'
      puts "#{cur_play.name} was sent to the penalty box"
      cur_play.in_penalty_box = true

      next_player
      true
    end

    def cur_play
      players[current_player]
    end

    private

    def ask_question
      puts @questions[current_category].shift
    end

    def current_category
      GameUtils.question_category(cur_play.place)
    end

    def did_player_win
      !(cur_play.purse == 6)
    end

    def next_player
      @current_player += 1
      @current_player = 0 if current_player == @players.length
    end

    def new_place(result)
      cur_play.place = cur_play.place + result
      cur_play.place = cur_play.place - PLACES if cur_play.place > PLACES - 1
      puts "#{cur_play.name}'s new location is #{cur_play.place}"
    end
  end
end
