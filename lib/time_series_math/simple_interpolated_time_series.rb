module TimeSeriesMath
  class SimpleInterpolatedTimeSeries < TimeSeries

    # Returns interpolated value.
    #
    def [](t)
      i0, i1 = indices_at(t)
      k = (t - @data[i0][0]) / (@data[i1][0] - @data[i0][0])
      diff_value = elemwise_sub(@data[i1][1], @data[i0][1])
      elemwise_add(@data[i0][1], elemwise_mul_scalar(k, diff_value))
    end

    # private

  end
end # module TimeSeriesMath
