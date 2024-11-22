# frozen_string_literal: true

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_shot, second_shot, third_shot)
    @first_shot = first_shot
    @second_shot = second_shot
    @third_shot = third_shot
  end

  def calculate_score
    @first_shot + @second_shot + @third_shot
  end

  BOWLING_PINS = 10

  def strike?
    @first_shot == BOWLING_PINS
  end

  def spare?
    @first_shot != BOWLING_PINS && @first_shot + @second_shot == BOWLING_PINS
  end

  def open_frame?
    @first_shot + @second_shot < BOWLING_PINS
  end
end
