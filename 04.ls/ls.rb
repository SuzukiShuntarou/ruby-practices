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

def show_long_format(filenames)
  puts "total #{filenames.map { |filename| (File.symlink?(filename) ? File.lstat(filename) : File.stat(filename)).blocks / 2 }.sum}"
  files_long_format = convert_long_format(filenames)

  max_show_length = {
    'nlink' => files_long_format.map { |file_long_format| file_long_format[1]['nlink'].length }.max,
    'user_name' => files_long_format.map { |file_long_format| file_long_format[1]['user_name'].length }.max,
    'group_name' => files_long_format.map { |file_long_format| file_long_format[1]['group_name'].length }.max,
    'file_size' => files_long_format.map { |file_long_format| file_long_format[1]['file_size'].length }.max
  }

  files_long_format.each do |file_long_format|
    print file_long_format[1]['permison']
    print file_long_format[1]['nlink'].to_s.ljust(max_show_length['nlink'], "\s")
    print file_long_format[1]['user_name'].to_s.ljust(max_show_length['user_name'], "\s")
    print file_long_format[1]['group_name'].to_s.ljust(max_show_length['group_name'], "\s")
    print file_long_format[1]['file_size'].to_s.rjust(max_show_length['file_size'], "\s")
    print file_long_format[1]['last_update_datetime']
    puts file_long_format[1]['file_name']
  end
end

def convert_long_format(filenames)
  files_details = {}
  filenames.each.with_index do |filename, key_id|
    file_status = File.symlink?(filename) ? File.lstat(filename) : File.stat(filename)

    filetype = file_status.mode.to_s(8)[0...-4].rjust(2, '0')
    special_authority = file_status.mode.to_s(8)[-4]
    authority = file_status.mode.to_s(8)[-3..]

    file_size = %w[02 06].include?(filetype) ? "#{file_status.rdev_major}, #{file_status.rdev_minor}\s" : "#{file_status.size}\s"

    files_details[key_id.to_s] = {
      'permison' => "#{convert_displayed_permission(filetype, special_authority, authority)}\s",
      'nlink' => "#{file_status.nlink}\s",
      'user_name' => "#{Etc.getpwuid(file_status.uid).name}\s",
      'group_name' => "#{Etc.getpwuid(file_status.gid).name}\s",
      'file_size' => file_size,
      'last_update_datetime' => "#{file_status.mtime.strftime('%b %d %H:%M')}\s",
      'file_name' => File.symlink?(filename) ? "#{filename} -> #{File.readlink(filename)}" : filename
    }
  end
  files_details
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

def convert_displayed_permission(filetype, special_authority, authority)
  displayed_filetype = filetype.gsub(/../) { |matched_type| FILE_TYPES[matched_type] }
  displayed_special_authority = special_authority.gsub(/./) { |matched_special_authority| SPECIAL_AUTHORITIES[matched_special_authority] }
  displayed_authority = authority.gsub(/[0-7]/) { |matched_authority| AUTHORITIES[matched_authority] }

  case special_authority
  when '1'
    displayed_authority[-1] = authority[-1].to_i.odd? ? displayed_special_authority : displayed_special_authority.upcase
  when '2'
    displayed_authority[-4] = authority[1].to_i.odd? ? displayed_special_authority : displayed_special_authority.upcase
  when '4'
    displayed_authority[2] = authority[0].to_i.odd? ? displayed_special_authority : displayed_special_authority.upcase
  end
  displayed_filetype + displayed_authority
end

main
