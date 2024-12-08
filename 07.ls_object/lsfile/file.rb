# frozen_string_literal: true

require 'etc'

module LsFile
  class File
    AUTHORITIES = {
      '0' => '---',
      '1' => '--x',
      '2' => '-w-',
      '3' => '-wx',
      '4' => 'r--',
      '5' => 'r-x',
      '6' => 'rw-',
      '7' => 'rwx'
    }.freeze

    attr_reader :name

    def initialize(name)
      @name = name
    end

    def permission
      type = status.directory? ? 'd' : '-'
      authority = status.mode.to_s(8).slice(-3..-1).gsub(/[0-7]/, AUTHORITIES)
      "#{type}#{authority}"
    end

    def link_count
      status.nlink
    end

    def owner_name
      Etc.getpwuid(status.uid).name
    end

    def group_name
      Etc.getpwuid(status.gid).name
    end

    def size
      status.size
    end

    def last_update_datetime
      status.mtime
    end

    def block_size
      status.blocks
    end

    private

    def status
      ::File.stat(@name)
    end
  end
end
