#!/usr/bin/env ruby
# frozen_string_literal: true

def main
  filenames = Dir.glob('*')
  show_file_list(filenames, 3)
end

def show_file_list(filenames, column_number)
  maximum_length = filenames.max_by(&:length).length

  nested_files = format_nested_filenames(filenames, column_number)
  nested_files.each do |files|
    files.each do |file|
      print file.ljust(maximum_length + 2) unless file.nil?
    end
    puts
  end
end

def format_nested_filenames(filenames, column_number)
  # 転置後の行列の列の数が指定の値になるように行の数を求める。
  row_number = filenames.size.ceildiv(column_number)

  filenames_adjusted_row_number = []
  first_column_number = 0
  column_number.times do
    filenames_adjusted_row_number << filenames.values_at(first_column_number...first_column_number + row_number)
    first_column_number += row_number
  end
  filenames_adjusted_row_number.transpose
end

main
