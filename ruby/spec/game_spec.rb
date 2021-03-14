require 'spec_helper'
require 'ugly_trivia/game'
require 'ugly_trivia/player'
require 'pry'

describe "game" do
  let(:game) { UglyTrivia::Game.new }
  let(:game2) { UglyTrivia::Game.new }
  before do
    2.times { |i| game.players.push(Player.new("Player #{i+1}")) }
  end

  context 'when adding players' do
    it 'allows adding valid player' do
      expect(game2.add_player("player 1")).to be true
      expect(game2.players.length).to eq 1
    end

    it 'does not allow adding more than 6 players' do
      6.times {|k| game2.add_player("player #{k}") }
      expect(game2.players.length).to eq 6
      expect(game2.add_player("seventh player")).to be false
      expect(game2.players.length).to eq 6
    end
  end

  context 'player in penalty box' do
    it 'gets out on odd roll' do
      game.current_player.in_penalty_box = true
      expect(game.remains_in_penalty_box(1)).to be false
      expect(game.current_player.in_penalty_box).to be false
    end
    it 'remains there on even roll' do
      game.current_player.in_penalty_box = true
      expect(game.remains_in_penalty_box(2)).to be true
      expect(game.current_player.in_penalty_box).to be true
    end
  end

  context 'when answering question' do
    before do
      game.current_player.in_penalty_box = false
      @before_gold = game.current_player.purse
      @before_player = game.current_player_position.to_i
    end

    context 'correctly' do
      context 'not in penalty box' do
        it 'returns true, adds gold to purse, and keeps player out of penalty box' do
          expect(game.correct_answer).to be true
          expect(game.players[@before_player].purse).to eq(@before_gold + 1)
          expect(game.players[@before_player].in_penalty_box).to be false
          expect(game.current_player_position).to be @before_player + 1
        end
      end
      context 'in penalty box' do
        it 'returns true, does not add gold, keeps player in penalty box' do
          game.current_player.in_penalty_box = true
          expect(game.correct_answer).to be true
          expect(game.players[@before_player].purse).to eq(@before_gold)
          expect(game.players[@before_player].in_penalty_box).to be true
        end
      end
      context 'sixth time' do
        it 'adds gold and returns false' do
          game.current_player.purse = 5
          expect(game.correct_answer).to be false
          expect(game.current_player.purse).to eq 6
        end
      end
      context 'many times' do
        it 'updates player positions correctly' do
          all = game.players.size
          position = game.current_player_position
          all.times { game.correct_answer }
          expect(game.current_player_position).to eq position
        end
      end
    end

    context 'incorrectly' do
      it 'adds no gold and puts player to penalty box' do
        expect(game.wrong_answer).to be true
        expect(game.players[@before_player].purse).to eq(@before_gold)
        expect(game.players[@before_player].in_penalty_box).to be true
      end
    end
  end

    context 'roll' do
      before do
        game.current_player.place = 0
        game.current_player.in_penalty_box = false
      end

      it 'is not allowed without min 2 players' do
        expect{ game2.roll 4 }.to raise_error(UglyTrivia::Game::InvalidGameException)
      end

      context 'player not in penalty box' do
        it 'updates place of player' do
          game.roll 4
          expect(game.current_player.place).to eq 4
          game.roll 8
          expect(game.current_player.place).to eq 1
        end
      end

      context 'player in penalty box' do
        before do
          game.current_player.in_penalty_box = true
        end

        context 'with odd result' do
          it 'updates place of player' do
            game.roll 5
            expect(game.current_player.place).to eq 5
            expect(game.current_player.in_penalty_box).to be false
          end
        end

        context 'with even result' do
          it 'does not update place of player nor release player from penalty box' do
            game.roll 6
            expect(game.current_player.place).to eq 0
            expect(game.current_player.in_penalty_box).to be true
          end
        end
      end
    end
end