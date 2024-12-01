# frozen_string_literal: true

class DirectoryFormatter < Directory
  COLUMN_COUNT = 3

  def format(long_option)
    if long_option
      ["total #{calculate_total_block_size}", build_long_format_files]
    else
      build_short_format_files
    end
  end

  private

  def build_long_format_files
    lengths = find_attributes_max_length
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

  def build_short_format_files
    nested_files = build_nested_files
    length = find_filename_max_length

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
end
