class Player

  def initialize(player_name)
    @player_name = player_name
    @place = 0
    @purse = 0
    @in_penalty_box = false
  end

  attr_accessor :player_name, :place, :purse, :in_penalty_box

end