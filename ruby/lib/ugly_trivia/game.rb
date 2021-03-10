require 'pry'
require_relative './game_utils'

module UglyTrivia
  class Game
    attr_accessor :players, :places, :purses, :in_penalty_box,
                  :current_player, :is_getting_out_of_penalty_box

    def initialize
      @players = []
      @places = Array.new(6, 0)
      @purses = Array.new(6, 0)
      @in_penalty_box = Array.new(6, nil)
      @current_player = 0
      @is_getting_out_of_penalty_box = false
      @questions = GameUtils.generate_questions
    end

    def is_playable?
      players.length >= 2
    end

    def add_player(player_name)
      if players.size == 6
        puts "Max 6 players allowed, not adding new player."
        return false
      end

      players.push player_name
      places[players.length] = 0
      purses[players.length] = 0
      in_penalty_box[players.length] = false

      puts "#{player_name} was added"
      puts "They are player number #{players.length}"

      true
    end

    def roll(result)
      puts "#{players[current_player]} is the current player"
      puts "They have rolled a #{result}"

      return if remains_in_penalty_box(result)

      new_place(result)
      puts "The category is #{current_category}"
      ask_question
    end

    def remains_in_penalty_box(result)
      return false unless in_penalty_box[current_player]

      if result % 2 == 0
        puts "#{players[current_player]} is not getting out of the penalty box"
        true
      else
        self.in_penalty_box[current_player] = false
        puts "#{players[current_player]} is getting out of the penalty box"
        false
      end
    end

    def correct_answer
      if in_penalty_box[current_player]
        next_player
        return true
      end

      puts 'Answer was correct!!!!'
      purses[current_player] += 1
      puts "#{@players[current_player]} now has #{purses[current_player]} Gold Coins."
      winner = did_player_win
      next_player
      winner
    end

    def wrong_answer
      puts 'Question was incorrectly answered'
      puts "#{@players[current_player]} was sent to the penalty box"
      in_penalty_box[current_player] = true

      next_player
      true
    end

    private

    def ask_question
      puts @questions[current_category].shift
    end

    def current_category
      GameUtils.question_category(places[current_player])
    end

    def did_player_win
      !(purses[current_player] == 6)
    end

    def next_player
      self.current_player += 1
      self.current_player = 0 if current_player == @players.length
    end

    def new_place(result)
      places[current_player] = places[current_player] + result
      places[current_player] = places[current_player] - 12 if places[current_player] > 11
      puts "#{@players[current_player]}'s new location is #{places[current_player]}"
    end
  end
end
