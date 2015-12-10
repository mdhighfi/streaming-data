#!/usr/bin/ruby

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

  def stats
    [@name, @count, @null_count]
  end
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

  def stats
    super + [@min, @max, @mean]
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

  def stats
    super + [@min_length, @max_length, @mean_length]
  end
end
