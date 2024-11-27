#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'

class Game
  def initialize(marks)
    @marks = marks
  end

  def calculate_score
    nested_frames = build_frames

    nested_frames.each_with_index.sum do |frames, count|
      current_frame = frames
      next_frame = nested_frames[count + 1] if count < 9
      after_next_frame = nested_frames[count + 2] if count < 8

      current_frame.calculate_score(next_frame, after_next_frame)
    end
  end

  private

  def build_frames
    shots = @marks.split(',').map { |mark| Shot.new(mark) }
    nested_frames = []

    count_by_shot = 0
    9.times do |count_by_frame|
      if shots[count_by_shot].strike?
        nested_frames[count_by_frame] = Frame.new([shots[count_by_shot]])
      else
        nested_frames[count_by_frame] = Frame.new([shots[count_by_shot], shots[count_by_shot + 1]])
        count_by_shot += 1
      end
      count_by_shot += 1
    end
    nested_frames << Frame.new(shots[count_by_shot..])
  end
end

if $PROGRAM_NAME == __FILE__
  game = Game.new(ARGV[0])
  puts game.calculate_score
end
