#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'

class Game
  def initialize(marks)
    @marks = marks
  end

  LAST_FRAME = 10
  NINE_FRAME = 9
  TWO_SHOTS = 2

  def calculate_score
    frames = build_frames
    point = 0
    frames.each.with_index(1) do |frame, count|
      now_frame = Frame.new(frame[0], frame[1], frame[2] || 0)
      next_frame = Frame.new(frames[count][0], frames[count][1], frames[count][2] || 0) if count < LAST_FRAME
      after_next_frame = Frame.new(frames[count + 1][0], frames[count][1], frames[count][2] || 0) if count < NINE_FRAME

      point += now_frame.calculate_score + calculate_bonus_score(now_frame, next_frame, after_next_frame)
    end
    point
  end

  private

  def build_frames
    shots = build_shots
    frames = shots.shift(NINE_FRAME * TWO_SHOTS).each_slice(TWO_SHOTS).to_a
    frames << shots
  end

  def build_shots
    shots = []
    @marks.split(',').map do |mark|
      shot = Shot.new(mark)
      shots << shot.score
      shots << 0 if shot.strike? && shots.length < NINE_FRAME * TWO_SHOTS
    end
    shots
  end

  def calculate_bonus_score(now_frame, next_frame, after_next_frame)
    return 0 if finished?(next_frame) || now_frame.open_frame?

    next_frame.first_shot +
      if now_frame.strike? && next_frame.strike? && after_next_frame
        after_next_frame.first_shot
      elsif now_frame.strike?
        next_frame.second_shot
      else
        0
      end
  end

  def finished?(next_frame)
    !next_frame
  end
end

if $PROGRAM_NAME == __FILE__
  game = Game.new(ARGV[0])
  puts game.calculate_score
end
