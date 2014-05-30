module TimeSeriesMath
  # Simple time series object.
  # Provides fast access to items by timestamp.
  #
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
        @data.insert(i+1, [t, v])
      end
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
        i += 1 while i+1 < size && t >= @data[i+1][0]
        i
      else
        # scan left
        i -= 1 while i > 0 && @data[i][0] > t
        i
      end
    end


  end
end # module TimeSeriesMath
