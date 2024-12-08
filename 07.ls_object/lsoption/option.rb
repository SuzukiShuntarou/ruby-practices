# frozen_string_literal: true

require 'optparse'

module LsOption
  def self.parse(argv)
    option = OptionParser.new
    @options = {}
    option.on('-a') { @options[:all] = true }
    option.on('-r') { @options[:reverse] = true }
    option.on('-l') { @options[:long] = true }
    option.parse!(argv)
  end

  def self.all?
    @options[:all]
  end

  def self.reverse?
    @options[:reverse]
  end

  def self.long?
    @options[:long]
  end
end
