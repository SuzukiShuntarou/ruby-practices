# frozen_string_literal: true

class Frame
  FULL_SCORE = 10
  attr_reader :shots

  def initialize(shots)
    @shots = shots
  end

  def calculate_score(next_frame, after_next_frame)
    sum_shots + calculate_bonus_score(next_frame, after_next_frame)
  end

  private

  def calculate_bonus_score(next_frame, after_next_frame)
    following_shots = [next_frame, after_next_frame].compact.flat_map(&:shots)
    if open_frame? || !next_frame
      0
    elsif spare?
      following_shots[0].score
    elsif strike?
      following_shots.first(2).sum(&:score)
    end
  end

  def strike?
    @shots[0].strike?
  end

  def spare?
    !strike? && sum_shots == FULL_SCORE
  end

  def open_frame?
    sum_shots < FULL_SCORE
  end

  def sum_shots
    @shots.sum(&:score)
  end
end
