# frozen_string_literal: true

require 'optparse'

module LsOption
  class << self
    def parse(argv)
      option = OptionParser.new
      @options = {}
      option.on('-a') { @options[:all] = true }
      option.on('-r') { @options[:reverse] = true }
      option.on('-l') { @options[:long] = true }
      option.parse!(argv)
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
  end
end
