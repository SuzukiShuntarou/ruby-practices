#!/usr/bin/env ruby
require 'optparse'
require 'date'

#引数の定義
opt = OptionParser.new
opt = ARGV.getopts('y:', 'm:')

#引数が与えられた時だけ指定の年、月とする
year = opt["y"] ? opt["y"].to_i : Time.now.year
month = opt["m"] ? opt["m"].to_i : Time.now.month

#calenderメソッド
def calendar(year, month)
  first_day = Date.new(year, month, 1)      #月の初日
  last_day = Date.new(year, month, -1)      #月の最終日
  puts " #{month}月 #{year}年\n 日 月 火 水 木 金 土"
  print "   " * Date.new(year, month).wday  #月の開始曜日前に半角スペースを追加
  (first_day..last_day).each do |date|      #1日から最終日までの数字を表示
    print "#{date.day}".rjust(3)
    puts  if date.saturday?                 #土曜日で改行
  end
end

#カレンダーメソッドの呼び出し
calendar(year, month)
