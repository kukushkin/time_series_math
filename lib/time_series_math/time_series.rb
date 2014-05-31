module TimeSeriesMath
  #
  # = TimeSeries
  # TimeSeries class provides an efficient data structure for storing timestamped data values.
  #
  # TimeSeries maintains order of its elements and provides efficient search methods
  # for near-constant time access
  # (depends strongly on timestamps distribution -- the more even, the better).
  #
  # == Examples:
  #
  #   require 'time_series_math'
  #   include TimeSeriesMath
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
    attr_reader :data, :processor

    # Creates a TimeSeries object.
    #
    # @param arr_t [Array<Float>] Array of timestamps
    # @param arr_v [Array] Array of corresponding values, should be of the same size as +arr_t+
    #
    # == Examples:
    #
    #   ts = TimeSeries.new # creates empty TimeSeries object
    #
    #   ts = TimeSeries.new([0.1, 0.5, 1.0], [120.0, 130.0, 140.0])
    #
    def initialize(arr_t = nil, arr_v = nil)
      @data = []
      @processor = nil
      push_array(arr_t, arr_v) if arr_t && arr_v
    end

    # @return number of values in the series
    #
    def size
      @data.size
    end

    # @return [Array] Array of timestamps
    #
    def keys
      @data.map { |d| d[0] }
    end

    # @return [Array] Array of values
    #
    def values
      @data.map { |d| d[1] }
    end

    # @return [Array, nil] First element of the time series
    #
    def first
      @data.first
    end

    # @return [Float, nil] Timestamp of the first element
    #
    def t_first
      first && first[0]
    end

    # @return [Array, nil] Last element of the time series
    #
    def last
      @data.last
    end

    # @return [Float, nil] Timestamp of the last element
    #
    def t_last
      last && last[0]
    end

    # Inserts new element into time series.
    # @param t [Float] Timestamp of the new value
    # @param v [Fixnum, Float, Array, Hash] New value
    #
    def push(t, v)
      t = t.to_f
      i = left_index_at(t)
      if i.nil?
        @data.unshift([t, v])
      else
        @data.insert(i + 1, [t, v])
      end
    end

    # Alias for #push(t, v)
    #
    # == Example:
    #
    #   ts = TimeSeries.new
    #   ts[1.0] = { x: 123.0 }
    #   ts[2.0] = { x: 125.0 }
    #
    #   ts[1.0] # => { x: 123.0 }
    #
    # @param (see #push)
    #
    def []=(t, v)
      push(t, v)
    end

    # Inserts batch of new values into time series. This method is more time efficient
    # than using #push to insert elements one by one.
    #
    # @param arr_t [Array] Array of timestamps
    # @param arr_v [Array] Array of corresponding values, should be of the same size as +arr_t+
    #
    def push_array(arr_t, arr_v)
      arr_data = arr_t.zip(arr_v)
      @data.concat(arr_data)
      @data.sort_by! { |d| d[0] }
    end

    # @return index of the element preceding +t+
    #
    def left_index_at(t)
      indices_at(t).first
    end

    # Returns value calculated at +t+.
    #
    # The actual value returned depends on the +processor+
    # used by TimeSeries object. When no +processor+ is used, the returned value is the value
    # of the last element preceding, or exactly at +t+.
    #
    def [](t)
      i = left_index_at(t)
      i && @data[i][1]
    end

    # @return [Array] indices of the elements surrounding +t+.
    #
    def indices_at(t)
      bsearch_indices_at(t)
    end

    # Use +processor+
    #
    def use(processor_module)
      @processor = processor_module
      extend processor_module
    end
  end # class TimeSeries
end # module TimeSeriesMath
