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
    ls_option = LsOption.new(@argv)
    directory = Directory.new(ls_option.all?)
    ls_formatter = LsFormatter.new(directory, ls_option.long?, ls_option.reverse?)
    puts ls_formatter.format
  end
end

ls = Ls.new(ARGV)
ls.exec
