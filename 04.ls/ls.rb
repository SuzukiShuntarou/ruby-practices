#!/usr/bin/env ruby
# frozen_string_literal: true

def filename_max_count(directory)
  filename_max = 0
  directory.each { |filename| filename_max = filename.length if filename_max < filename.length }
  filename_max
end

def alignment_two_dimensional_array(directory, column_number)
  # 転置後の行列の列の数が指定の値になるように行の数を求める。
  row_number = directory.size.ceildiv(column_number)

  adjust_row_number_two_dimensional_array = []
  while adjust_row_number_two_dimensional_array << directory.values_at(0...row_number)
    directory.slice!(0...row_number)
    break if directory.empty?
  end
  adjust_row_number_two_dimensional_array.transpose
end

def formatting(directory, column_number)
  maxcount = filename_max_count(directory)
  two_dimention_array = alignment_two_dimensional_array(directory, column_number)

  two_dimention_array.each do |file_column_array|
    file_column_array.each do |file|
      print file.ljust(maxcount + 2) unless file.nil?
    end
    puts
  end
end

# カレントディレクトリの取得
current_directory = Dir.glob('*')

formatting(current_directory, 3)
