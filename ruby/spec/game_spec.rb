require 'spec_helper'
require 'ugly_trivia/game'
require 'pry'

describe "game" do
  let(:game) { UglyTrivia::Game.new }

  context 'when adding players' do
    it 'allows adding valid player' do
      expect(game.add_player("player 1")).to be true
      expect(game.players.length).to eq 1
    end

    it 'does not allow adding more than 6 players' do
      6.times {|k| game.add_player("player #{k}") }
      expect(game.players.length).to eq 6
      expect(game.add_player("seventh player")).to be false
      expect(game.players.length).to eq 6
    end
  end

  context "when asking for category" do
    it 'returns correct one based on players place on board' do
      game.places[game.current_player] = 4
      expect(game.current_category).to eq "Pop"
      game.places[game.current_player] = 6
      expect(game.current_category).to eq "Sports"
      game.places[game.current_player] = 65
      expect(game.current_category).to eq "Rock"
    end
  end

  context "generate questions" do
    it 'creates a correct hash object' do
      questions = game.generate_questions(["Pop"], 1)
      expect(questions[:Pop]).to eq ["Pop Question 0"]

      questions = game.generate_questions(["Pop", "Rock"], 2)
      expect(questions[:Pop][0]).to eq "Pop Question 0"
      expect(questions[:Rock][1]).to eq "Rock Question 1"
    end
  end

end