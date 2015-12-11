#!/usr/bin/ruby

require_relative 'column'

class Table
  def initialize
    @columns = []
  end

  def [](i)
    @columns[i]
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

  def to_s
    @columns.each do |col|
      p col
    end
  end
end
