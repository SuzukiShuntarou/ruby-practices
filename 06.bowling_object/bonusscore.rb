# frozen_string_literal: true

class BonusScore
  def initialize(args)
    @frame_point = args[:frame_point]
    @frame_count = args[:frame_count]
    @now_frame = args[:now_frame]
    @next_frame = args[:next_frame]
    @frame_after_next = args[:frame_after_next]
  end

  BEFORE_FINAL_FRAME = 9
  FINAL_FRAME = 10

  def score
    if @frame_point == 10 && @frame_count != FINAL_FRAME
      @next_frame[:first_shot] +
        if @now_frame[:first_shot] != 10
          0
        elsif @next_frame[:first_shot] != 10 || @frame_count == BEFORE_FINAL_FRAME
          @next_frame[:second_shot]
        else
          @frame_after_next[:first_shot]
        end
    else
      0
    end
  end
end
