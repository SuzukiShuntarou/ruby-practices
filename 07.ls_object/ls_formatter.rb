# frozen_string_literal: true

class LsFormatter
  COLUMN_COUNT = 3

  def initialize(directory, option_long, option_reverse)
    @directory = directory
    @option_long = option_long
    @option_reverse = option_reverse
  end

  def format
    if @option_long
      "total #{@directory.calculate_total_block_size}\n#{build_long_format_files.join("\n")}"
    else
      build_short_format_files
    end
  end

  private

  def build_long_format_files
    lengths = @directory.attributes_max_length
    sort_files.map do |file|
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
    length = @directory.filename_max_length

    nested_files.map do |files|
      files.map { |file| file&.name&.ljust(length + 2) }.join('')
    end
  end

  def build_nested_files
    row_count = @directory.files.length.ceildiv(COLUMN_COUNT)
    nested_files = sort_files.each_slice(row_count).to_a
    nil_count = row_count - nested_files.last.length
    # 各要素のサイズが不揃いだとtransposeメソッドでエラーが発生するのでサイズを揃える
    nested_files.last.concat(Array.new(nil_count))
    nested_files.transpose
  end

  def sort_files
    sorted_files = @directory.files.sort_by do |file|
      [
        file.name.sub(/^\.+/, '').downcase,
        file.name.match?(/^\.+$/) ? file.name.count('.') : -file.name.count('.')
      ]
    end
    @option_reverse ? sorted_files.reverse : sorted_files
  end
end
