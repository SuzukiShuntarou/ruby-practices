# frozen_string_literal: true

require_relative '../game'
require 'minitest/autorun'

class BowlingTest < Minitest::Test
  def test_pattern_one
    game_pattern_one = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
    assert_equal 139, game_pattern_one.score
  end

  def test_pattern_two
    game_pattern_two = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X')
    assert_equal 164, game_pattern_two.score
  end

  def test_pattern_three
    game_pattern_three = Game.new('0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4')
    assert_equal 107, game_pattern_three.score
  end

  def test_pattern_four
    game_pattern_four = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0')
    assert_equal 134, game_pattern_four.score
  end

  def test_pattern_five
    game_pattern_five = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8')
    assert_equal 144, game_pattern_five.score
  end

  def test_perfect_game
    perfect_game = Game.new('X,X,X,X,X,X,X,X,X,X,X,X')
    assert_equal 300, perfect_game.score
  end

  def test_almost_perfect_game
    almost_perfect_game = Game.new('X,X,X,X,X,X,X,X,X,X,X,2')
    assert_equal 292, almost_perfect_game.score
  end

  def test_spare_and_zero_game
    spare_and_zero_game = Game.new('X,0,0,X,0,0,X,0,0,X,0,0,X,0,0')
    assert_equal 50, spare_and_zero_game.score
  end
end
