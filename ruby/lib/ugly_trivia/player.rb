class Player

  def initialize(name)
    @name = name
    @place = 0
    @purse = 0
    @in_penalty_box = false
  end

  attr_accessor :name, :place, :purse, :in_penalty_box

end