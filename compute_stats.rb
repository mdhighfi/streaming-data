#!/usr/bin/ruby

require 'open3'
require_relative 'table'
require_relative 'column'

num_rows = ARGV[0].to_i
unless (num_rows.is_a?(Fixnum) && num_rows.between?(1,1_000_000))
  num_rows = 1000
end

IO.popen("./generator #{num_rows}") do |stream|
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
  puts table
end
