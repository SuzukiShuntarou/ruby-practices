#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'
require_relative 'bonusscore'

class Game
  def initialize(args)
    @scores = args[:scores]
    @shots = []
    @frames = []
  end

  def score
    convert_scores_to_frames.map.with_index(1) do |frame_point, frame_count|
      point = frame(frame_point[:first_shot], frame_point[:second_shot], frame_point[:third_shot]).score
      point + bonusscore(point, frame_count).score
    end.sum
  end

  NINE_FRAME = 9
  TWO_SHOTS = 2

  def convert_scores_to_frames
    @scores.split(',').each do |score|
      @shots << shot(score).score
      @shots << 0 if score == 'X' && @shots.length < NINE_FRAME * TWO_SHOTS
    end

    keys = %i[first_shot second_shot third_shot]
    @shots.shift(NINE_FRAME * TWO_SHOTS).each_slice(TWO_SHOTS) do |value|
      @frames << keys.zip(value).to_h
    end
    @frames << keys.zip(@shots).to_h
  end

  def frame(first_shot, second_shot, third_shot)
    Frame.new(first_shot:, second_shot:, third_shot:)
  end

  def bonusscore(frame_point, frame_count)
    now_frame = @frames[frame_count - 1]
    next_frame = @frames[frame_count]
    frame_after_next = @frames[frame_count + 1]
    BonusScore.new(frame_point:, frame_count:, now_frame:, next_frame:, frame_after_next:)
  end

  def shot(score)
    Shot.new(score)
  end
end

game = Game.new(scores: ARGV[0])
puts game.score
