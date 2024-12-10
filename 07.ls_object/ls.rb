#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lsoption/option'
require_relative 'directory'
require_relative 'lsformatter'
require_relative 'lsfile/file'

class Ls
  def initialize(argv = nil)
    LsOption.parse(argv)
  end

  def show_file_list
    lsformatter = LsFormatter.new(build_files)
    puts lsformatter.format(LsOption.long?)
  end

  private

  def build_files
    sort_filenames.map { |filename| LsFile::File.new(filename) }
  end

  def sort_filenames
    filenames = LsOption.all? ? Dir.foreach('.').to_a : Dir.glob('*')
    sorted_filenames = filenames.sort_by do |filename|
      [
        filename.sub(/^\.+/, '').downcase,
        filename.match?(/^\.+$/) ? filename.count('.') : -filename.count('.')
      ]
    end
    LsOption.reverse? ? sorted_filenames.reverse : sorted_filenames
  end
end

ls = Ls.new(ARGV)
ls.show_file_list
