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

if params[:m] && params[:y] #引数が-y,-mどちらも渡された時
  year  = opt.parse!(ARGV).map!(&:to_i).max
  month = opt.parse!(ARGV).map!(&:to_i).min
elsif params[:m]            #月だけの場合は今年の月を返す
  year  = Time.now.year
  month = opt.parse!(ARGV).map!(&:to_i)[0]
else                        #引数がない場合は今日の日付を返す
  year  = Time.now.year
  month = Time.now.month
end

#calenderメソッド
def calendar(year, month)
  count_day = Date.new(year, month, 1)        #カウント用、初期値は指定月の1日
  last_day = Date.new(year, month, -1).day    #月の最終日を定義
  puts " #{month}月 #{year}年\n 日 月 火 水 木 金 土"
  print "   " * Date.new(year, month).wday    #月の開始曜日前に半角スペースを追加
  (1..last_day).each do |day|                 #1日から最終日までの数字を表示
    print "#{day}".rjust(3)
    puts "" if count_day.saturday?            #土曜日で改行
    count_day += 1
  end
end

#カレンダーメソッドの呼び出し
calendar(year, month)
