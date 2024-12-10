#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lsoption/option'
require_relative 'directory'
require_relative 'directoryformatter'
require_relative 'lsfile/file'

class Ls
  def initialize(argv = nil)
    LsOption.parse(argv)
  end

  def show_file_list
    directoryformatter = DirectoryFormatter.new(build_files)
    puts directoryformatter.format(LsOption.long?)
  end

  private

  def build_files
    sort_filenames.map do |filename|
      LsFile::File.new(filename)
    end
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
