# frozen_string_literal: true

class Directory
  def initialize(files)
    @files = files
  end

  private

  def calculate_total_block_size
    @files.sum(&:block_size) / 2
  end

  def find_attributes_max_length
    %i[link_count owner_name group_name size].to_h do |key|
      values = @files.map do |file|
        file.send(key).to_s.length
      end
      [key, values.max]
    end
  end

  def find_filename_max_length
    @files.map { |file| file.name.length }.max
  end
end
