# frozen_string_literal: true

require_relative '../game'
require 'minitest/autorun'

class BowlingTest < Minitest::Test
  def test_pattern_one
    game = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
    assert_equal 139, game.calculate_score
  end

  def test_pattern_two
    game = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X')
    assert_equal 164, game.calculate_score
  end

  def test_pattern_three
    game = Game.new('0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4')
    assert_equal 107, game.calculate_score
  end

  def test_pattern_four
    game = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0')
    assert_equal 134, game.calculate_score
  end

  def test_pattern_five
    game = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8')
    assert_equal 144, game.calculate_score
  end

  def test_perfect_game
    game = Game.new('X,X,X,X,X,X,X,X,X,X,X,X')
    assert_equal 300, game.calculate_score
  end

  def test_almost_perfect_game
    game = Game.new('X,X,X,X,X,X,X,X,X,X,X,2')
    assert_equal 292, game.calculate_score
  end

  def test_spare_and_zero_game
    game = Game.new('X,0,0,X,0,0,X,0,0,X,0,0,X,0,0')
    assert_equal 50, game.calculate_score
  end
end
