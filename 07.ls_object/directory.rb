# frozen_string_literal: true

class Directory
  COLUMN_COUNT = 3

  def initialize(files)
    @files = files
  end

  def format(long_option)
    if long_option
      ["total #{total_block_size}", format_long_files]
    else
      format_short_files
    end
  end

  private

  def format_long_files
    lengths = attributes_max_length
    @files.map do |file|
      [
        file.permission,
        file.link_count.to_s.rjust(lengths[:link_count], ' '),
        file.owner_name.to_s.rjust(lengths[:owner_name], ' '),
        file.group_name.to_s.rjust(lengths[:group_name], ' '),
        file.size.to_s.rjust(lengths[:size], ' '),
        file.last_update_datetime.strftime('%b %d %H:%M'),
        file.name
      ].join(' ')
    end
  end

  def format_short_files
    nested_files = build_nested_files
    length = filename_max_length

    nested_files.map do |files|
      files.map { |file| file&.name&.ljust(length + 2) }.join('')
    end
  end

  def build_nested_files
    row_count = @files.length.ceildiv(COLUMN_COUNT)
    nested_files = @files.each_slice(row_count).to_a
    nil_count = row_count - nested_files.last.length
    # 各要素のサイズが不揃いだとtransposeメソッドでエラーが発生するのでサイズを揃える
    nested_files.last.concat(Array.new(nil_count))
    nested_files.transpose
  end

  def total_block_size
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
