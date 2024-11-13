# frozen_string_literal: true

class Frame
  def initialize(args)
    @first_shot = args[:first_shot]
    @second_shot = args[:second_shot]
    @third_shot = args[:third_shot] || default_score
  end

  def score
    [@first_shot, @second_shot, @third_shot].sum
  end

  def default_score
    0
  end
end
