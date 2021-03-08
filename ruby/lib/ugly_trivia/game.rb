require 'pry'

module UglyTrivia
  class Game
    def initialize
      @players = []
      @places = Array.new(6, 0)
      @purses = Array.new(6, 0)
      @in_penalty_box = Array.new(6, nil)
      initialize_questions

      @current_player = 0
      @is_getting_out_of_penalty_box = false
    end

    def initialize_questions
      @pop_questions = []
      @science_questions = []
      @sports_questions = []
      @rock_questions = []

      50.times do |i|
        @pop_questions.push "Pop Question #{i}"
        @science_questions.push "Science Question #{i}"
        @sports_questions.push "Sports Question #{i}"
        @rock_questions.push "Rock Question #{i}"
      end
    end

    attr_accessor :players, :places, :purses

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
      @in_penalty_box[players.length] = false

      puts "#{player_name} was added"
      puts "They are player number #{players.length}"

      true
    end

    def roll(result)
      puts "#{players[@current_player]} is the current player"
      puts "They have rolled a #{result}"

      if @in_penalty_box[@current_player]
        if result % 2 == 0
          puts "#{players[@current_player]} is not getting out of the penalty box"
          @is_getting_out_of_penalty_box = false
          return
        else
          @is_getting_out_of_penalty_box = true
          puts "#{players[@current_player]} is getting out of the penalty box"
        end
      end
      new_place(result)
      puts "The category is #{current_category}"
      ask_question
    end

    def correct_answer
      if @in_penalty_box[@current_player]
        if @is_getting_out_of_penalty_box
          puts 'Answer was correct!!!!'
          @purses[@current_player] += 1
          puts "#{@players[@current_player]} now has #{@purses[@current_player]} Gold Coins."

          winner = did_player_win()
          next_player

          winner
        else
          next_player
          true
        end
      else
        puts "Answer was corrent!!!!"
        @purses[@current_player] += 1
        puts "#{@players[@current_player]} now has #{@purses[@current_player]} Gold Coins."

        winner = did_player_win
        next_player

        winner
      end
    end

    def wrong_answer
      puts 'Question was incorrectly answered'
      puts "#{@players[@current_player]} was sent to the penalty box"
      @in_penalty_box[@current_player] = true

      next_player
      true
    end

    def ask_question
      puts @pop_questions.shift if current_category == 'Pop'
      puts @science_questions.shift if current_category == 'Science'
      puts @sports_questions.shift if current_category == 'Sports'
      puts @rock_questions.shift if current_category == 'Rock'
    end

    def current_category
      case @places[@current_player]
      when 0,4,8
        'Pop'
      when 1,5,9
        'Science'
      when 2,6,10
        'Sports'
      else
        'Rock'
      end
    end

    def did_player_win
      !(@purses[@current_player] == 6)
    end

    def next_player
      @current_player += 1
      @current_player = 0 if @current_player == @players.length
    end

    def new_place(result)
      @places[@current_player] = @places[@current_player] + result
      @places[@current_player] = @places[@current_player] - 12 if @places[@current_player] > 11
      puts "#{@players[@current_player]}'s new location is #{@places[@current_player]}"
    end
  end
end
