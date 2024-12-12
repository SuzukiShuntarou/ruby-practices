#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lsoption'
require_relative 'directory'
require_relative 'lsformatter'
require_relative 'lsfile/file'

class Ls
  def initialize(argv = nil)
    @argv = argv
  end

  def show_file_list
    lsoption = LsOption.new(@argv)
    directory = Directory.new(lsoption.all?)
    lsformatter = LsFormatter.new(directory, lsoption.long?, lsoption.reverse?)
    puts lsformatter.format
  end
end

ls = Ls.new(ARGV)
ls.show_file_list
