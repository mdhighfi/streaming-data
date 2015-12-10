#!/usr/bin/ruby

require 'open3'

types = []
names = []
header = true

IO.popen("./generator 10") do |stream|
  while line = stream.gets
    values = line.split(',').map(&:strip)
    if header
      values.each_with_index do |val, col|
        _, names[col], types[col] = val.match(/(\w+) \((\w+)/).to_a
      end
      header = false
    else
      values.each_with_index do |val, col|
        p "#{names[col]}: #{val}, (#{types[col]})"
      end
    end
  end
end
