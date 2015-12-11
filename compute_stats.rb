#!/usr/bin/ruby

require 'open3'
require_relative 'table'
require_relative 'column'

IO.popen("./generator 10000") do |stream|
  table = Table.new
  is_header = true
  while line = stream.gets
    line = line.split(',').map!(&:strip)
    if is_header
      table.define_columns(line)
      is_header = false
    else
      line.each_with_index do |val, col|
        table[col].update_stats(val)
      end
    end
  end
  i = 0
  until table[i].nil?
    puts table[i]
    puts
    i += 1
  end
end
