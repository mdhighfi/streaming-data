#!/usr/bin/ruby

class Column
  SPACE = 26
  STATS = %w[
    count null_count
  ]
  NUM_STATS = %w[
    count null_count min max mean
  ]
  TEXT_STATS = %w[
    count null_count shortest count_shortest longest count_longest
    mean_length
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
    [@count, @null_count]
  end

  def to_s
    len = @name.length
    result = '-'*(len + SPACE) + "\n"
    result +=
      '|' + ' '*(SPACE/2-1) + @name +
      ' '*(SPACE/2-1) + '|' + "\n"
    result += '-'*(len + SPACE) + "\n"
    stats.each_with_index do |stat, idx|
      stat = stat.round(3).to_s if stat.is_a?(Float)
      text = NUM_STATS[idx] + ": #{stat}" if self.is_a?(NumberColumn)
      text = TEXT_STATS[idx] + ": #{stat}" if self.is_a?(TextColumn)
      num_spaces = len + SPACE - text.length - 2
      result += '|' + ' '*(num_spaces - 3) + text + ' '*3 + "|\n"
    end
    result += '-'*(len + SPACE) + "\n"
  end
end

class NumberColumn < Column

  def initialize(name, num)
    super
    @min = nil
    @max = 0
    @mean = 0
  end

  def convert_type(val)
    return val.to_f if val.match('.')
    return val.to_i unless val.empty?
    nil
  end

  def update_stats(val)
    super
    val = convert_type(val)
    @min ||= val
    @min = val if !val.nil? && !@min.nil? && val < @min
    @max = val if !val.nil? && val > @max

    unless val.nil?
      @mean = ((@count -1) * @mean + val) / @count.to_f
    end
  end

  def stats
    super + [@min, @max, @mean]
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
      @count_longest = 1
    end

    if length == @longest.length
      if val > @longest
        @longest = val
        @count_longest = 1
      elsif val == @longest
        @count_longest += 1
      end
    end

    unless val.empty?
      if @shortest.nil?
        @shortest = val
        @count_shortest = 1
      elsif (length < @shortest.length)
        @shortest = val
        @count_shortest = 1
      elsif (length == @shortest.length)
        if (val < @shortest)
          @shortest = val
          @count_shortest = 1
        else
          @count_shortest += 1
        end
      end
    end

    @mean_length = ((@count -1) * @mean_length + length) / @count.to_f
  end

  def stats
    super + [
      @shortest, @count_shortest, @longest, @count_longest,
      @mean_length
    ]
  end
end
