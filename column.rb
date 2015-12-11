#!/usr/bin/ruby

class Column
  SPACE = 18
  STATS = %w[
    name count null_count
  ]
  NUM_STATS = %w[
    name count null_count min max mean
  ]
  TEXT_STATS = %w[
    name count null_count count_shortest count_longest mean_length
  ]


  def initialize(name, number)
    @name = name
    @number = number
    @count = 0
    @null_count = 0
  end

  def update_stats(val)
    @count += 1
    @null_count += 1 if val == ''
    val = convert_type(val)
  end

  def convert_type(val)
    # implemented in child classes
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

  def convert_type(val)
    return val.to_f if val.match('.')
    val.to_i
  end

  def update_stats(val)
    super
    val = convert_type(val)
    @min = val if val < @min
    @max = val if val > @max
  end

  def stats
    super + [@min, @max, @mean]
  end

  def to_s
    len = @name.length
    result = '-'*(len + SPACE) + "\n"
    result +=
      '|' + ' '*(SPACE/2-1) + @name +
      ' '*(SPACE/2-1) + '|' + "\n"
    result += '-'*(len + SPACE) + "\n"
    stats.each_with_index do |stat, idx|
      text = NUM_STATS[idx] + ": #{stat}"
      num_spaces = len + SPACE - text.length - 2
      result += '|' + ' '*(num_spaces - 3) + text + ' '*3 + "|\n"
    end
    result += '-'*(len + SPACE) + "\n"
  end
end

class TextColumn < Column

  def initialize(name, num)
    super
    @shortest = nil
    @longest = ''
    @count_shortest = 0
    @count_longest = 0
    @mean_length = 0
  end

  def update_stats(val)
    super
    length = val.length
    if length > @longest.length
      @longest = val
      length
    end

    if @shortest.nil?
      @shortest = val
      @count_shortest += 1
    end

    if (length < @shortest.length)
      @shortest, @count_shortest = val, length
    end

    if (length == @shortest.length) && (val < @shortest)
      @shortest, @count_shortest = val, length
    end

    @mean_length = ((@count -1) * @mean_length + length) / @count
  end

  def stats
    super + [@count_shortest, @count_longest, @mean_length]
  end

  def to_s
    len = @name.length
    result = '-'*(len + SPACE) + "\n"
    result +=
      '|' + ' '*(SPACE/2-1) + @name +
      ' '*(SPACE/2-1) + '|' + "\n"
    result += '-'*(len + SPACE) + "\n"
    stats.each_with_index do |stat, idx|
      text = TEXT_STATS[idx] + ": #{stat}"
      num_spaces = len + SPACE - text.length - 2
      result += '|' + ' '*(num_spaces - 3) + text + ' '*3 + "|\n"
    end
    result += '-'*(len + SPACE) + "\n"
  end
end
