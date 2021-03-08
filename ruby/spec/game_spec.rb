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
      expect(game.current_category).to eq "Pop"
    end
  end

end