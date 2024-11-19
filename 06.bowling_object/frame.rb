# frozen_string_literal: true

class Frame
  def initialize(point, frame_count, now_frame, next_frame, frame_after_next)
    @point = point
    @frame_count = frame_count
    @now_frame = now_frame
    @next_frame = next_frame
    @frame_after_next = frame_after_next
  end

  BEFORE_FINAL_FRAME = 9
  FINAL_FRAME = 10

  def score
    @point +=
      if @point == 10 && @frame_count != FINAL_FRAME
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
