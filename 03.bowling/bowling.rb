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
point = frames.each.with_index(1).sum do |frame, frame_count|
  frame_sum = frame.sum
  next frame_sum if frame.sum < 10 || frame_count == 10

  next_frame_first_shot_sum = frame_sum + frames[frame_count][0]
  next_frame_first_shot_sum + if frame[0] != 10 # spare
                                0
                              elsif frames[frame_count][0] != 10 || frame_count == NINE_FRAME # 連続strikeでない
                                frames[frame_count][1]
                              else #  連続strike
                                frames[frame_count + 1][0]
                              end
end
puts point
