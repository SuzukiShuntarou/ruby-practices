#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  stdin = $stdin
  options, filenames = parse_options(ARGV)
  files, length =
    if filenames.any?
      contents = convert_to_count_contents(read_files(filenames))
      [contents, find_max_length(contents)]
    else
      stdin_files = []
      stdin_files << {
        name: nil,
        content: stdin.readlines
      }
      [convert_to_count_contents(stdin_files), 0]
    end
  show_count_contents(files, options, length)
end

def parse_options(argv)
  option = OptionParser.new
  options = {}
  option.on('-l') { options[:line] = true }
  option.on('-w') { options[:word] = true }
  option.on('-c') { options[:character] = true }

  filenames = option.parse(argv)
  %i[line word character].each { |key| options[key] = true } if options.empty?
  [options, filenames]
end

def read_files(files)
  files.map do |file|
    File.open(file) do |f|
      {
        name: file,
        content: f.readlines
      }
    end
  end
end

def convert_to_count_contents(files)
  files.map do |file|
    {
      filename: file[:name],
      line: file[:content].join.count("\n").to_s,
      word: file[:content].map { |test| test.split.size }.sum.to_s,
      character: file[:content].map(&:bytesize).sum.to_s
    }
  end
end

def find_max_length(files)
  total = [
    files.map { |file| file[:line].to_i }.sum.to_s,
    files.map { |file| file[:word].to_i }.sum.to_s,
    files.map { |file| file[:character].to_i }.sum.to_s
  ]
  total.map(&:length).max
end

def show_count_contents(contents, options, max_length)
  contents.each do |content|
    %i[line word character].each do |key|
      next if !options[key]

      rjust_length = content[:filename] || options.size == 1 ? max_length : 7
      print "#{content[key].rjust(rjust_length, ' ')} "
    end
    puts content[:filename]
  end
  show_total(contents, options, max_length) if contents.size > 1
end

def show_total(files, options, max_length)
  total = {}
  %i[line word character].each do |key|
    total[key] = files.map { |file| file[key].to_i }.sum.to_s if options[key]
  end
  formatted_total_counts = total.values.map { |value| value.rjust(max_length, ' ') }
  puts "#{formatted_total_counts.join(' ')} total"
end

main
