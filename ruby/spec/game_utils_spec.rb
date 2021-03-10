require 'spec_helper'
require 'ugly_trivia/game_utils'

describe "GameUtils" do

  it "creates questions" do
      questions = GameUtils.generate_questions()
      expect(questions[:Pop][0]).to eq "Pop Question 0"
      expect(questions[:Rock][1]).to eq "Rock Question 1"
  end

  it 'returns correct question category' do
    expect(GameUtils.question_category(4)).to eq :Pop
    expect(GameUtils.question_category(6)).to eq :Sports
    expect(GameUtils.question_category(7)).to eq :Rock
  end

end