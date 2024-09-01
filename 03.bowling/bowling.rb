#!/usr/bin/env ruby
# frozen_string_literal: true

# 引数の取り出し
scores = ARGV[0].split(',')
shots = []
NINE_FRAME = 9
TWO_SHOTS = 2

# 取り出した引数をshots配列へ保存
scores.each do |score|
  if score == 'X' # strikeの時
    shots << 10
    shots << 0 if shots.length < (NINE_FRAME * TWO_SHOTS) # 9フレーム目まで、10フレーム目では0を追加しない。
  else
    shots << score.to_i
  end
end

# 9フレーム目まで２投ごとにframes配列へ保存
frames = shots.shift(NINE_FRAME * TWO_SHOTS).each_slice(TWO_SHOTS).to_a

# 10フレーム目は残りのスコア全てframes配列へ保存
frames << shots

# ポイントの計算
point = frames.each.with_index(1).sum do |frame_point, frame_count|
  common_calcu = frame_point.sum
  next common_calcu if frame_point.sum < 10 || frame_count == 10

  common_calcu += frames[frame_count][0]
  next common_calcu if frame_point[0] != 10 # spare

  # strike
  if frames[frame_count][0] != 10 || frame_count == NINE_FRAME # 連続strikeでない
    common_calcu + frames[frame_count][1]
  else
    common_calcu + frames[frame_count + 1][0]
  end
end
puts point
