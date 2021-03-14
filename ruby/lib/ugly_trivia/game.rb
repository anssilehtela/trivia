require 'pry'
require_relative './game_utils'
require_relative './player'

module UglyTrivia
  class Game
    attr_accessor :players, :places, :purses, :in_penalty_box,
                  :current_player_position, :is_getting_out_of_penalty_box
    PLACES = 11
    GOLD_TO_WIN = 6
    class InvalidGameException < StandardError
    end

    def initialize
      @players = []
      @current_player_position = 0
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
      puts "#{current_player.name} is the current player"
      puts "They have rolled a #{result}"

      return if remains_in_penalty_box(result)

      update_player_place(result)
      puts "The category is #{current_category}"
      ask_question
    end

    def remains_in_penalty_box(result)
      return false unless current_player.in_penalty_box

      if result % 2 == 0
        puts "#{current_player.name} is not getting out of the penalty box"
        true
      else
        current_player.in_penalty_box = false
        puts "#{current_player.name} is getting out of the penalty box"
        false
      end
    end

    def correct_answer
      if current_player.in_penalty_box
        update_player_position
        return true
      end

      puts 'Answer was correct!!!!'
      current_player.purse += 1
      puts "#{current_player.name} now has #{current_player.purse} Gold Coins."
      return false if winner?
      update_player_position
      true
    end

    def wrong_answer
      puts 'Question was incorrectly answered'
      puts "#{current_player.name} was sent to the penalty box"
      current_player.in_penalty_box = true

      update_player_position
      true
    end

    def current_player
      players[current_player_position]
    end

    private

    def ask_question
      puts @questions[current_category].shift
    end

    def current_category
      GameUtils.question_category(current_player.place)
    end

    def winner?
      current_player.purse == GOLD_TO_WIN
    end

    def update_player_position
      @current_player_position += 1
      @current_player_position = 0 if current_player_position == @players.length
    end

    def update_player_place(result)
      current_player.place = current_player.place + result
      current_player.place = current_player.place - PLACES if current_player.place > PLACES - 1
      puts "#{current_player.name}'s new location is #{current_player.place}"
    end
  end
end
