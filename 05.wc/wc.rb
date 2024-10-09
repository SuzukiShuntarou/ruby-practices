#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  option = OptionParser.new
  options = {}
  option.on('-l') { options[:line] = true }
  option.on('-w') { options[:word] = true }
  option.on('-c') { options[:character] = true }

  option.parse!(ARGV)
  %i[line word character].each { |key| options[key] = true } if options.empty?

  if File.pipe?($stdin)
    show_inputs_in_wcformat(convert_inputs_to_wcformat, options)
  else
    show_files_in_wcformat(convert_files_to_wcformat, options)
  end
end

def show_inputs_in_wcformat(inputs, options)
  %i[line word character].each do |key|
    if options.size == 1 && options[key]
      print inputs[key]
    elsif options[key]
      print "#{inputs[key].rjust(7, ' ')} "
    end
  end
  puts
end

def convert_inputs_to_wcformat
  inputs = $stdin.readlines
  {
    line: inputs.join.count("\n").to_s,
    word: inputs.map { |input| input.split.size }.sum.to_s,
    character: inputs.map(&:bytesize).sum.to_s
  }
end

def show_files_in_wcformat(files, options)
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

def convert_files_to_wcformat
  files = []
  ARGV.each do |file|
    File.open(file) do |f|
      file_contents = f.readlines
      files << {
        filename: file,
        line: file_contents.join.count("\n").to_s,
        word: file_contents.size.to_s,
        character: file_contents.map(&:bytesize).sum.to_s
      }
    end
  end
  files
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
