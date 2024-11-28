#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'

class Game
  def initialize(marks)
    @marks = marks
  end

  def calculate_score
    frames = build_frames
    10.times.sum do |count|
      current_frame, next_frame, after_next_frame = frames[count, 3]
      current_frame.calculate_score(next_frame, after_next_frame)
    end
  end

  private

  def build_frames
    shots = @marks.split(',').map { |mark| Shot.new(mark) }
    frames = []
    shot_pos = 0
    9.times do |frame_index|
      length = shots[shot_pos].strike? ? 1 : 2
      frames[frame_index] = Frame.new(shots[shot_pos, length])
      shot_pos += length
    end
    [*frames, Frame.new(shots[shot_pos..])]
  end
end

if $PROGRAM_NAME == __FILE__
  game = Game.new(ARGV[0])
  puts game.calculate_score
end
