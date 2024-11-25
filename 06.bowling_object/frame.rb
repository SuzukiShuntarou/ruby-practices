# frozen_string_literal: true

class Frame
  FULL_SCORE = 10
  attr_reader :shots

  def initialize(shots)
    @shots = shots
  end

  def calculate_score(next_frame, after_next_frame)
    sum_shots +
      if open_frame? || !next_frame
        0
      elsif spare?
        next_frame.shots[0].score
      elsif next_frame.strike? && after_next_frame
        next_frame.shots[0].score + after_next_frame.shots[0].score
      else
        next_frame.shots[0].score + next_frame.shots[1].score
      end
  end

  def strike?
    @shots[0].strike?
  end

  def spare?
    score = sum_shots
    !@shots[0].strike? && score == FULL_SCORE
  end

  def open_frame?
    score = sum_shots
    score < FULL_SCORE
  end

  def sum_shots
    @shots.sum(&:score)
  end
end
