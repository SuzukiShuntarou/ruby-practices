#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'

class Game
  def initialize(scores)
    @scores = scores
  end

  def score
    @frames = []
    convert_scores_to_frames.map.with_index(1) do |frame, frame_count|
      calculate_frame_score(frame[:first_shot] + frame[:second_shot] + (frame[:third_shot] || 0), frame_count)
    end.sum
  end

  private

  NINE_FRAME = 9
  TWO_SHOTS = 2

  def convert_scores_to_frames
    shots = []
    @scores.split(',').each do |score|
      shots << Shot.new(score).score
      shots << 0 if score == 'X' && shots.length < NINE_FRAME * TWO_SHOTS
    end

    keys = %i[first_shot second_shot third_shot]
    shots.shift(NINE_FRAME * TWO_SHOTS).each_slice(TWO_SHOTS) do |value|
      @frames << keys.zip(value).to_h
    end
    @frames << keys.zip(shots).to_h
  end

  def calculate_frame_score(point, frame_count)
    now_frame = @frames[frame_count - 1]
    next_frame = @frames[frame_count]
    frame_after_next = @frames[frame_count + 1]
    Frame.new(point, frame_count, now_frame, next_frame, frame_after_next).score
  end
end

game = Game.new(ARGV[0])
puts game.score
