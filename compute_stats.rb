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

  def define_columns(values)
    values.each_with_index do |val, col|
      _, names[col], types[col] = val.match(/(\w+) \((\w+)/).to_a
      case types[col]
      when 'text'
        table << TextColumn.new(names[col], col)
      when 'number'
        table << NumberColumn.new(names[col], col)
      else
        table << Column.new(names[col], col)
      end
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

  def update_stats(row)
    # implemented in child classes
  end

end

class NumberColumn < Column
  def initialize(name, num)
    super(name, num)
    @min = 0
    @max = 0
    @mean = 0
  end

  def update_stats(row)
  end
end

class TextColumn < Column
  def initialize(name, num)
    super(name, num)
    @min = ''
    @max = ''
    @mean_length = 0
  end

  def update_stats(row)
    @count += 1
    @null_count += 1 if
  end

end


types = []
names = []
header = true



IO.popen("./generator 10") do |stream|
  table = []
  while line = stream.gets
    values = line.split(',').map(&:strip)
    if header
      define_columns
    else
      values.each_with_index do |val, col|
        table[col].update_stats()
      end
    end
  end
end
