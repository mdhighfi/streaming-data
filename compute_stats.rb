#!/usr/bin/ruby

require 'open3'


class Table
  def initialize
    @columns = []
  end

  def [](i,j)
    @columns[i][j]
  end

  def []=(i,j,val)
    @columns[i][j] = val
  end

  def define_columns(header)
    header.each_with_index do |val, col|
      _, name, type = val.match(/(\w+) \((\w+)/).to_a
      case type
      when 'text'
        @columns << TextColumn.new(name, col)
      when 'number'
        @columns << NumberColumn.new(name, col)
      else
        @columns << Column.new(name, col)
      end
    end
  end

  def stats
    @columns.map do |col|
      col.stats
    end
  end
end

class Column
  def initialize(name, number)
    @name = name
    @number = number
    @count = 0
    @null_count = 0
  end

  def update_stats(val)
    @null_count += 1 if val == ''
  end

  def
end

class NumberColumn < Column
  def initialize(name, num)
    super
    @min = 0
    @max = 0
    @mean = 0
  end

  def update_stats(val)
    super
    @min = val if val < @min
    @max = val if val > @max
  end
end

class TextColumn < Column
  def initialize(name, num)
    super
    @min_length = ''
    @max_length = ''
    @mean_length = 0
  end

  def update_stats(val)
    super
    length = val.length
    @count += 1
    @mean_length = ((@count -1) * @mean_length + length) / @count
    @min_length = length if length < @min_length
    @max_length = length if length > @max_length
  end
end



IO.popen("./generator 10") do |stream|
  table = Table.new
  is_header? = true
  while line = stream.gets
    line.split!(',').map!(&:strip)
    if is_header?
      table.define_columns(line)
      is_header? = false
    else
      line.each_with_index do |val, col|
        table[col].update_stats(val)
      end
    end
  end
  p table.stats
end
