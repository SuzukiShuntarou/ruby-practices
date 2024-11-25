#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'

class Game
  def initialize(marks)
    @marks = marks
  end

  def calculate_score
    nested_shots = build_shots

    nested_shots.map.with_index do |shots, count|
      current_frame = Frame.new(shots)
      next_frame = Frame.new(nested_shots[count + 1]) if count < 9
      after_next_frame = Frame.new(nested_shots[count + 2]) if count < 8

      current_frame.calculate_score(next_frame, after_next_frame)
    end.sum
  end

  private

  def build_shots
    shots = @marks.split(',').map { |mark| Shot.new(mark) }
    nested_shots = []

    shots.each_with_index do |shot, count|
      if nested_shots.last.to_a.include?(shot)
        next
      elsif nested_shots.length == 9
        nested_shots[9] = shots[count..]
      elsif shot.strike?
        nested_shots << [shot]
      else
        nested_shots << [shot, shots[count + 1]]
      end
    end
    nested_shots
  end
end

if $PROGRAM_NAME == __FILE__
  game = Game.new(ARGV[0])
  puts game.calculate_score
end
