#!/usr/bin/ruby

require 'open3'
require_relative 'table'
require_relative 'column'

num_rows = ARGV[0]
if num_rows.nil?
  num_rows = 1_000
end
num_rows = num_rows.to_i
if num_rows.is_a?(Fixnum)
  if num_rows > 1_000_000
    num_rows = 1_000_000
  elsif num_rows < 1
    num_rows = 1
  end
else
  num_rows = 1000
end

puts "generating #{num_rows} records..."

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
