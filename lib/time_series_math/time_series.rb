module TimeSeriesMath
  #
  # TimeSeries class provides an efficient data structure for storing timestamped data values.
  #
  # TimeSeries maintains order of its elements and provides efficient search methods
  # for near-constant time access
  # (depends strongly on timestamps distribution -- the more even, the better).
  #
  # Examples:
  #
  #   # one by one element insertion
  #   ts = TimeSeries.new
  #   ts.push 1.0, { x: 2.0, y: 3.0 }
  #   ts.push 1.2, { x: 2.0, y: 3.0 }
  #   ts.push 1.6, { x: 2.0, y: 3.0 }
  #   ts.push 1.9, { x: 2.0, y: 3.0 }
  #   ts.push 2.1, { x: 2.0, y: 3.0 }
  #
  #   # more time-efficient batch insertion using arrays:
  #   ts = TimeSeries.new
  #   tt = [ 1.0, 1.2, 1.6, 1.9, 2.1 ]
  #   dd = [ {x: 2.0}, {x: 2.1}, {x: 2.5}, {x: 2.7}, {x: 2.85} ]
  #   ts.push_array(tt, dd)
  #
  #   # retrieve closest element before given time
  #   ts[1.2] # => { x: 2.1 }
  #   ts[2.095] # => { x: 2.7 }

  class TimeSeries
    attr_reader :data

    def initialize(arr_t = nil, arr_v = nil)
      @data = []
      push_array(arr_t, arr_v) if arr_t && arr_v
    end

    def size
      @data.size
    end

    def keys
      @data.map { |d| d[0] }
    end

    def values
      @data.map { |d| d[1] }
    end

    def first
      @data.first
    end

    def t_first
      first && first[0]
    end

    def last
      @data.last
    end

    def t_last
      last && last[0]
    end

    def push(t, v)
      t = t.to_f
      i = left_index_at(t)
      if i.nil?
        @data.unshift([t, v])
      else
        @data.insert(i + 1, [t, v])
      end
    end

    def []=(t, v)
      push(t, v)
    end

    def push_array(arr_t, arr_v)
      arr_data = arr_t.zip(arr_v)
      @data.concat(arr_data)
      @data.sort_by! { |d| d[0] }
    end

    def left_index_at(t)
      t = t.to_f
      return nil if size == 0 || t_first > t
      return (size - 1) if t_last <= t
      d = (t - t_first) / (t_last - t_first)
      i = (d * size.to_f).to_i
      if @data[i][0] <= t
        # scan right
        i += 1 while i + 1 < size && t >= @data[i + 1][0]
        i
      else
        # scan left
        i -= 1 while i > 0 && @data[i][0] > t
        i
      end
    end

    def [](t)
      i = left_index_at(t)
      i && @data[i][1]
    end

    def indices_at(t)
      li = left_index_at(t)
      if li
        if @data.size == li+1
          [li, nil]
        else
          [li, li+1]
        end
      elsif @data.size > 0
        [nil, 0]
      end
    end
  end # class TimeSeries
end # module TimeSeriesMath
