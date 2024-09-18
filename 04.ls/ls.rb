#!/usr/bin/env ruby
# frozen_string_literal: true

COLUMN_COUNT = 3

def main
  filenames = Dir.glob('*')
  show_file_list(filenames)
end

def show_file_list(filenames)
  maximum_length = filenames.max_by(&:length).length

  nested_file_names = transpose_nested_filenames(filenames)
  nested_file_names.each do |file_names|
    file_names.each do |file_name|
      print file_name.ljust(maximum_length + 2) unless file_name.nil?
    end
    puts
  end
end

def transpose_nested_filenames(filenames)
  # 転置後の行列の列の数が指定の値になるように行の数を求める。
  row_count = filenames.length.ceildiv(COLUMN_COUNT)

  nested_file_names = []
  filenames.each_slice(row_count) { |filename| nested_file_names << filename }
  # 転置行列を作成するため、二次元配列の最後の要素に不足分があればnilで埋め尽くす。
  nil_count = row_count - nested_file_names.last.length
  nested_file_names.last.concat(Array.new(nil_count))

  nested_file_names.transpose
end

main
