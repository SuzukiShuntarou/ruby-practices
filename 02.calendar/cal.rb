#!/usr/bin/env ruby
require 'optparse'
require 'date'

#引数の定義
opt = OptionParser.new
params = {}
opt.on('-m'){ |month| params[:m] = month }
opt.on('-y'){ |year|  params[:y] = year }

#引数の取り出し
opt.parse!(ARGV)

#引数が-y,-mどちらも渡されないと今日の日付をcalenderメソッドへ渡す
if params[:m] && params[:y]
  year  = opt.parse!(ARGV).map!(&:to_i).max
  month = opt.parse!(ARGV).map!(&:to_i).min
else
  year  = Time.now.year
  month = Time.now.month
end

#calenderメソッド
def calendar(y, m)
  puts " #{m}月 #{y}年\n 日 月 火 水 木 金 土"
  #月の日数をカウントする変数mday
  mday = 1 
  #月の開始曜日前に半角スペースを追加
  unless Date.new(y, m, mday).sunday?
    print "   " * Date.new(y, m).cwday
  end
  while mday <= Date.new(y, m, -1).day
    if !Date.new(y, m, mday).saturday?
      if mday < 10
        print "  #{mday}"
      elsif
        print " #{mday}"
      end
    elsif mday < 10
      puts "  #{mday}"
    else
      puts " #{mday}"
    end
    mday += 1
  end
end

#カレンダーメソッドの呼び出し
calendar(year, month)
