#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  argv = ARGV
  stdin = $stdin
  options = parse_options(argv)
  if argv.any?
    files = convert_to_count_contents(read_files(argv))
    show_files(files, options)
  elsif !stdin.eof?
    stdin_files = []
    stdin_files << {
      name: nil,
      content: stdin.readlines
    }
    inputs = convert_to_count_contents(stdin_files)
    show_inputs(inputs, options)
  end
end

def parse_options(argv)
  option = OptionParser.new
  options = {}
  option.on('-l') { options[:line] = true }
  option.on('-w') { options[:word] = true }
  option.on('-c') { options[:character] = true }

  option.parse!(argv)
  %i[line word character].each { |key| options[key] = true } if options.empty?
  options
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

def show_inputs(inputs, options)
  inputs.each do |input|
    %i[line word character].each do |key|
      if options.size == 1 && options[key]
        print input[key]
      elsif options[key]
        print "#{input[key].rjust(7, ' ')} "
      end
    end
    puts
  end
end

def show_files(files, options)
  total = {}
  max_length = find_max_length(files)
  files.each do |file|
    %i[line word character].each do |key|
      if options[key]
        print "#{file[key].rjust(max_length, ' ')} "
        total[key] = convert_to_total(key, files).to_s if files.size > 1
      end
    end
    puts file[:filename]
  end

  display = total.values.map { |value| value.rjust(max_length, ' ') }
  puts "#{display.join(' ')} total" if files.size > 1
end

def convert_to_total(key, files)
  files.map { |file| file[key].to_i }.sum
end

def find_max_length(files)
  total = [
    files.map { |file| file[:line].to_i }.sum.to_s,
    files.map { |file| file[:word].to_i }.sum.to_s,
    files.map { |file| file[:character].to_i }.sum.to_s
  ]
  total.map(&:length).max
end

main
