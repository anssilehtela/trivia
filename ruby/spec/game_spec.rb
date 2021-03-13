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

  context 'player in penalty box' do
    before do
      game.in_penalty_box[game.current_player] = true
    end
    it 'gets out on odd roll' do
      expect(game.remains_in_penalty_box(1)).to be false
      expect(game.in_penalty_box[game.current_player]).to be false
    end
    it 'remains there on even roll' do
      expect(game.remains_in_penalty_box(2)).to be true
      expect(game.in_penalty_box[game.current_player]).to be true
    end
  end

  context 'when answering question' do
    # let(:before_gold) { game.purses[game.current_player].to_i }
    # let(:before_player) { game.current_player.to_i }

    before do
      game.in_penalty_box[game.current_player] = false
      @before_gold = game.purses[game.current_player]
      @before_player = game.current_player.to_i
    end

    context 'correctly' do
      it 'adds gold to purse' do
        game.correct_answer
        expect(game.purses[@before_player]).to eq(@before_gold + 1)
        expect(game.in_penalty_box[@before_player]).to be false
      end
    end

    context 'incorrectly' do
      it 'adds no gold and puts player to penalty box' do
        game.wrong_answer
        expect(game.purses[@before_player]).to eq(@before_gold)
        expect(game.in_penalty_box[@before_player]).to be true
      end
    end
  end

end