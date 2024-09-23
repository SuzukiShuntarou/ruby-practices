#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
COLUMN_COUNT = 3

def main
  option = OptionParser.new
  options = {}
  option.on('-a') { options[:all] = true }
  option.on('-r') { options[:reverse] = true }

  option.parse!(ARGV)
  filenames = options[:all] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
  filenames.reverse! if options[:reverse]
  show_file_list(filenames)
end

def show_file_list(filenames)
  max_length = filenames.max_by(&:length).length

  nested_file_names = convert_nested_filenames(filenames)
  nested_file_names.each do |file_names|
    file_names.each do |file_name|
      print file_name.ljust(max_length + 2) unless file_name.nil?
    end
    puts
  end
end

def convert_nested_filenames(filenames)
  row_count = filenames.length.ceildiv(COLUMN_COUNT)

  nested_file_names = filenames.each_slice(row_count).to_a
  # 各要素のサイズが不揃いだとtransposeメソッドでエラーが発生するのでサイズを揃える
  nil_count = row_count - nested_file_names.last.length
  nested_file_names.last.concat(Array.new(nil_count))

  nested_file_names.transpose
end

main
