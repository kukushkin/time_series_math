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

    # Element-wise addition of objects
    #
    def elemwise_add(obj1, obj2)
      case obj1
      when Array
        obj1.clone.zip(obj2).map { |d| d[0] + d[1] }
      when Hash
        out = {}
        obj1.each { |k, v| out[k] = v + obj2[k] }
        out
      else
        obj1 + obj2
      end
    end

    # Element-wise substraction of objects
    #
    def elemwise_sub(obj1, obj2)
      case obj1
      when Array
        obj1.clone.zip(obj2).map { |d| d[0] - d[1] }
      when Hash
        out = {}
        obj1.each { |k, v| out[k] = v - obj2[k] }
        out
      else
        obj1 - obj2
      end
    end

    # Element-wise multiplication by scalar
    #
    def elemwise_mul_scalar(scalar, obj)
      case obj
      when Array
        obj.clone.map { |d| d * scalar }
      when Hash
        out = {}
        obj.each { |k, v| out[k] = v * scalar }
        out
      else
        obj * scalar
      end
    end
  end
end # module TimeSeriesMath
