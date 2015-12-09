#!/usr/bin/ruby

require 'csv'
require 'open3'

stdin, stdout, stderr = Open3.popen3("#{Dir.getwd}/../generator", "4")

p "standard output: #{stdout.gets}"
p "standard output: #{stdout.gets}"
p "standard output: #{stdout.gets}"
p "standard output: #{stdout.gets}"
p "standard output: #{stdout.gets}"
