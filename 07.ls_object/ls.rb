#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'directory'
require_relative 'directoryformatter'
require_relative 'file'
require 'optparse'

class Ls
  def initialize(argv = nil)
    parse_options(argv)
  end

  def show_file_list
    puts build_directory.format(long?)
  end

  private

  def build_directory
    filenames = []
    all? ? Dir.foreach('.') { |file| filenames << file } : filenames = Dir.glob('*')
    sorted_filenames = filenames.sort_by { |filename| filename.sub(/^\./, '').downcase }

    files = sorted_filenames.map do |filename|
      CustomFile::File.new(filename)
    end
    DirectoryFormatter.new(reverse? ? files.reverse : files)
  end

  def all?
    @options[:all]
  end

  def reverse?
    @options[:reverse]
  end

  def long?
    @options[:long]
  end

  def parse_options(argv)
    option = OptionParser.new
    @options = {}
    option.on('-a') { @options[:all] = true }
    option.on('-r') { @options[:reverse] = true }
    option.on('-l') { @options[:long] = true }
    option.parse!(argv)
  end
end

ls = Ls.new(ARGV)
ls.show_file_list
