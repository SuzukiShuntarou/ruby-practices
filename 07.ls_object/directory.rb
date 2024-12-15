# frozen_string_literal: true

class Directory
  attr_reader :files

  def initialize(all)
    paths = all ? Dir.foreach('.').to_a : Dir.glob('*')
    @files = paths.map { |path| LsFile.new(path) }
  end

  def calculate_total_block_size
    @files.sum(&:block_size) / 2
  end

  def attributes_max_length
    %i[link_count owner_name group_name size].to_h do |key|
      values = @files.map do |file|
        file.send(key).to_s.length
      end
      [key, values.max]
    end
  end

  def filename_max_length
    @files.map { |file| file.name.length }.max
  end
end
