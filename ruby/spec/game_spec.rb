require 'spec_helper'
require 'ugly_trivia/game'
require 'ugly_trivia/player'
require 'pry'

describe "game" do
  let(:game) { UglyTrivia::Game.new }
  let(:player1) { Player.new("Player1") }
  before do
    game.players.push(player1)
  end

  context 'when adding players' do
    let(:game2) { UglyTrivia::Game.new }
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
      game.cur_play.in_penalty_box = true
      expect(game.remains_in_penalty_box(1)).to be false
      expect(game.cur_play.in_penalty_box).to be false
    end
    it 'remains there on even roll' do
      game.cur_play.in_penalty_box = true
      expect(game.remains_in_penalty_box(2)).to be true
      expect(game.cur_play.in_penalty_box).to be true
    end
  end

  context 'when answering question' do

    before do
      game.cur_play.in_penalty_box = false
      @before_gold = game.cur_play.purse
      @before_player = game.current_player.to_i
    end

    context 'correctly' do
      it 'adds gold to purse' do
        game.correct_answer
        expect(game.cur_play.purse).to eq(@before_gold + 1)
        expect(game.cur_play.in_penalty_box).to be false
      end
    end

    context 'incorrectly' do
      it 'adds no gold and puts player to penalty box' do
        game.wrong_answer
        expect(game.cur_play.purse).to eq(@before_gold)
        expect(game.cur_play.in_penalty_box).to be true
      end
    end
  end

    context 'roll' do
      before do
        game.cur_play.place = 0
        game.cur_play.in_penalty_box = false
      end

      context 'player not in penalty box' do
        it 'updates place of player and asks question' do
          binding.pry
          #expect(game).to receive(:ask_question)
          game.roll 4
          expect(game.cur_play.place).to eq 4
        end
      end

      context 'player in penalty box' do
        before do
          game.cur_play.in_penalty_box = true
        end

        context 'with odd result' do
          it 'updates place of player and asks question' do
            #expect(game).to receive(:ask_question)
            game.roll 5
            expect(game.cur_play.place).to eq 5
            expect(game.cur_play.in_penalty_box).to be false
          end
        end
      end
      context 'even for player in penalty box' do
        context 'player in penalty box' do
          it 'does not update place of player or ask a question' do
            #expect(game).to_not receive(:ask_question)
            game.roll 6
            expect(game.cur_play.place).to eq 6
            expect(game.cur_play.in_penalty_box).to be true
          end
        end
      end
    end

end