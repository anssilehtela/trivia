require 'spec_helper'
require 'ugly_trivia/player'
require 'pry'

describe "player" do

  it "can be created" do
    player = Player.new("Player1")
    expect(player.player_name).to eq "Player1"
    expect(player.place).to eq 0
    expect(player.purse).to eq 0
    expect(player.in_penalty_box).to be false
  end

end