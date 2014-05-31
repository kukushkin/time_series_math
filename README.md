# TimeSeriesMath

Time series data structures and functions.

## Installation

Add this line to your application's Gemfile:

    gem 'time_series_math'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install time_series_math

## Usage

### TimeSeries

`TimeSeries` class is a data structure for storing timestamped values.

TimeSeries maintains order of its elements and provides efficient search methods
for near-constant time access
(depends strongly on timestamps distribution -- the more even, the better).

Examples:

``` ruby
require 'time_series_math'

include TimeSeriesMath

# one by one element insertion:
ts = TimeSeries.new
ts.push 1.0, { x: 2.0, y: 3.0 }
ts.push 1.2, { x: 2.0, y: 3.0 }
ts.push 1.6, { x: 2.0, y: 3.0 }
ts.push 1.9, { x: 2.0, y: 3.0 }
ts.push 2.1, { x: 2.0, y: 3.0 }
# .. or:
ts[2.3] = { x: 2.5, y: 3.5 }
ts[2.5] = { x: 2.2, y: 3.7 }

# more time-efficient batch insertion using arrays:
ts = TimeSeries.new
tt = [ 1.0, 1.2, 1.6, 1.9, 2.1 ]
dd = [ {x: 2.0}, {x: 2.1}, {x: 2.5}, {x: 2.7}, {x: 2.85} ]
ts.push_array(tt, dd)

# retrieve closest element before given time:
ts[1.2] # => { x: 2.1 }
ts[2.095] # => { x: 2.7 }
```

## Contributing

1. Fork it ( https://github.com/kukushkin/time_series_math/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
