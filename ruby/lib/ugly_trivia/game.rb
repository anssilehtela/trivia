require 'pry'
require_relative './game_utils'
require_relative './player'

module UglyTrivia
  class Game
    attr_accessor :players, :places, :purses, :in_penalty_box,
                  :current_player, :is_getting_out_of_penalty_box, :players2
    PLACES = 11
    GOLD_TO_WIN = 6
    class InvalidGameException < StandardError
    end

    def initialize
      @players = []
      @current_player = 0
      @questions = GameUtils.generate_questions
    end

    def playable?
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
      raise InvalidGameException, 'too few players' unless playable?
      puts "#{player.name} is the current player"
      puts "They have rolled a #{result}"

      return if remains_in_penalty_box(result)

      new_place(result)
      puts "The category is #{current_category}"
      ask_question
    end

    def remains_in_penalty_box(result)
      return false unless player.in_penalty_box

      if result % 2 == 0
        puts "#{player.name} is not getting out of the penalty box"
        true
      else
        player.in_penalty_box = false
        puts "#{player.name} is getting out of the penalty box"
        false
      end
    end

    def correct_answer
      if player.in_penalty_box
        next_player
        return true
      end

      puts 'Answer was correct!!!!'
      player.purse += 1
      puts "#{player.name} now has #{player.purse} Gold Coins."
      return false if winner?
      next_player
      true
    end

    def wrong_answer
      puts 'Question was incorrectly answered'
      puts "#{player.name} was sent to the penalty box"
      player.in_penalty_box = true

      next_player
      true
    end

    def player
      players[current_player]
    end

    private

    def ask_question
      puts @questions[current_category].shift
    end

    def current_category
      GameUtils.question_category(player.place)
    end

    def winner?
      player.purse == GOLD_TO_WIN
    end

    def next_player
      @current_player += 1
      @current_player = 0 if current_player == @players.length
    end

    def new_place(result)
      player.place = player.place + result
      player.place = player.place - PLACES if player.place > PLACES - 1
      puts "#{player.name}'s new location is #{player.place}"
    end
  end
end
