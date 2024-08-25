#!/usr/bin/env ruby
# frozen_string_literal: true

# 引数の取り出し
scores = ARGV[0].split(',')
shots = []

# 取り出した引数をshots配列へ保存
scores.each do |score|
  if score == 'X' # strikeの時
    shots << 10
    shots << 0 if shots.length < 18 # 9フレーム目まで、10フレーム目では0を追加しない。
  else
    shots << score.to_i
  end
end

# 9フレーム目まで２投ごとにframes配列へ保存
frames = []
shots.each_slice(2).with_index do |shot, frame|
  frames[frame] = shot if frame < 9
end

# 10フレーム目は残りのスコア全てframes配列へ保存
shots.shift(18)
frames << shots

# ポイントの計算
point = 0
frames.each.with_index(1) do |frame_point, frame_count|
  if frame_point.sum < 10 || frame_count == 10 # spare/strikeでない or 10フレーム目
    point += frame_point.sum
  elsif frame_point[0] == 10 && frames[frame_count][0] == 10 # 連続strike
    point += 20 + frames[frame_count + 1][0] if frame_count < 9
    point += 20 + frames[frame_count][1] if frame_count == 9
  elsif frame_point[0] == 10 # strike
    point += 10 + frames[frame_count][0] + frames[frame_count][1]
  else # spare
    point += 10 + frames[frame_count][0]
  end
end
puts point
