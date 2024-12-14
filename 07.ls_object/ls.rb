#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'ls_option'
require_relative 'directory'
require_relative 'ls_formatter'
require_relative 'ls_file'

class Ls
  def initialize(argv = nil)
    @argv = argv
  end

  def exec
    lsoption = LsOption.new(@argv)
    directory = Directory.new(lsoption.all?)
    lsformatter = LsFormatter.new(directory, lsoption.long?, lsoption.reverse?)
    puts lsformatter.format
  end
end

ls = Ls.new(ARGV)
ls.exec
