#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'

class Game
  def initialize(marks)
    @marks = marks
  end

  def calculate_score
    shots = build_shots

    shots.map.with_index do |shot, count|
      current_frame = Frame.new(shot)
      next_frame = Frame.new(shots[count + 1]) if count < 9
      after_next_frame = Frame.new(shots[count + 2]) if count < 8

      current_frame.calculate_score(next_frame, after_next_frame)
    end.sum
  end

  private

  def build_shots
    shots = @marks.split(',').map { |mark| Shot.new(mark) }
    split_shots = []

    shots.each_with_index do |shot, count|
      if split_shots.last.to_a.include?(shot)
        next
      elsif split_shots.length == 9
        split_shots[9] = shots[count..]
      elsif shot.strike?
        split_shots << [shot]
      else
        split_shots << [shot, shots[count + 1]]
      end
    end
    split_shots
  end
end

if $PROGRAM_NAME == __FILE__
  game = Game.new(ARGV[0])
  puts game.calculate_score
end
