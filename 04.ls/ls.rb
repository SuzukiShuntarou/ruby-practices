#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'
COLUMN_COUNT = 3

def main
  option = OptionParser.new
  options = {}
  option.on('-a') { options[:all] = true }
  option.on('-r') { options[:reverse] = true }
  option.on('-l') { options[:long] = true }

  option.parse!(ARGV)
  filenames = options[:all] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
  sorted_filenames = filenames.reverse if options[:reverse]

  if options[:long]
    show_long_format(filenames)
  else
    show_file_list(sorted_filenames || filenames)
  end
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

CHARACTER_SPECIAL_FILETYPE = '02'
BLOCK_SPECIAL_FILETYPE = '06'

def show_long_format(filenames)
  file_details = fetch_file_details(filenames)
  total = file_details.map { |file_detail| file_detail[:file_block_size] }.sum / 2
  puts "total #{total}"

  max_lengths = %i[nlink user_name group_name file_size].to_h do |key|
    [key, find_max_length(key, file_details)]
  end

  file_details.each do |file_detail|
    print "#{file_detail[:permison]} "
    print "#{file_detail[:nlink].to_s.ljust(max_lengths[:nlink], ' ')} "
    print "#{file_detail[:user_name].ljust(max_lengths[:user_name], ' ')} "
    print "#{file_detail[:group_name].ljust(max_lengths[:group_name], ' ')} "

    if [CHARACTER_SPECIAL_FILETYPE, BLOCK_SPECIAL_FILETYPE].include?(file_detail[:filetype])
      print "#{file_detail[:file_device][:major]}, #{file_detail[:file_device][:minor]} "
    else
      print "#{file_detail[:file_size].to_s.rjust(max_lengths[:file_size], ' ')} "
    end

    print "#{file_detail[:last_update_datetime].strftime('%b %d %H:%M')} "
    puts file_detail[:file_link_name] ? "#{file_detail[:filename]} -> #{file_detail[:file_link_name]}" : file_detail[:filename]
  end
end

def fetch_file_details(filenames)
  filenames.map do |filename|
    file_status = File.symlink?(filename) ? File.lstat(filename) : File.stat(filename)
    file_link_name = File.readlink(filename) if File.symlink?(filename)
    filetype = file_status.mode.to_s(8)[0...-4].rjust(2, '0')

    {
      permison: convert_permission(filetype, file_status),
      nlink: file_status.nlink,
      user_name: Etc.getpwuid(file_status.uid).name,
      group_name: Etc.getpwuid(file_status.gid).name,
      file_size: file_status.size,
      file_block_size: file_status.blocks,
      file_device: { major: file_status.rdev_major, minor: file_status.rdev_minor },
      last_update_datetime: file_status.mtime,
      filetype:,
      file_link_name:,
      filename:
    }
  end
end

def find_max_length(key, file_details)
  file_details.map { |file_detail| file_detail[key].to_s.length }.max
end

FILE_TYPES = {
  '01' => 'p',
  '02' => 'c',
  '04' => 'd',
  '06' => 'b',
  '10' => '-',
  '12' => 'l',
  '14' => 's'
}.freeze

SPECIAL_AUTHORITIES = {
  '1' => 't',
  '2' => 's',
  '4' => 's'
}.freeze

AUTHORITIES = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

EXECUTABLE = '1'
WRITABLE = '2'
READABLE = '4'

def convert_permission(filetype, file_status)
  special_authority = file_status.mode.to_s(8)[-4]
  authority = file_status.mode.to_s(8)[-3..]

  filetype_value = filetype.gsub(/../, FILE_TYPES)
  special_authority_value = special_authority.gsub(/./, SPECIAL_AUTHORITIES)
  authority_value = authority.gsub(/[0-7]/, AUTHORITIES)

  case special_authority
  when EXECUTABLE
    authority_value[-1] = authority[-1].to_i.odd? ? special_authority_value : special_authority_value.upcase
  when WRITABLE
    authority_value[-4] = authority[1].to_i.odd? ? special_authority_value : special_authority_value.upcase
  when READABLE
    authority_value[2] = authority[0].to_i.odd? ? special_authority_value : special_authority_value.upcase
  end
  filetype_value + authority_value
end

main
