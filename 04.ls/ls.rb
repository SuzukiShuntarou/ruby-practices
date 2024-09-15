#!/usr/bin/env ruby
# frozen_string_literal: true

COLUMN_COUNT = 3

def main
  filenames_in_dir = Dir.glob('*')
  show_file_list(filenames_in_dir, COLUMN_COUNT)
end

def show_file_list(filenames_in_dir, column_count)
  maximum_length = filenames_in_dir.max_by(&:length).length

  nested_filenames = format_nested_filenames(filenames_in_dir, column_count)
  nested_filenames.each do |filenames|
    filenames.each do |filename|
      print filename.ljust(maximum_length + 2) unless filename.nil?
    end
    puts
  end
end

def format_nested_filenames(filenames_in_dir, column_count)
  # 転置後の行列の列の数が指定の値になるように行の数を求める。
  row_count = filenames_in_dir.length.ceildiv(column_count)

  nested_filenames_adjusted_by_row_count = []
  first_column_number = 0
  column_count.times do
    nested_filenames_adjusted_by_row_count << filenames_in_dir[first_column_number, row_count]
    first_column_number += row_count
  end
  # 転置行列を作成するため、二次元配列の最後の要素に不足分があればnilで埋め尽くす。
  (row_count - nested_filenames_adjusted_by_row_count.last.length).times do
    nested_filenames_adjusted_by_row_count.last.push(nil)
  end

  nested_filenames_adjusted_by_row_count.transpose
end

main
