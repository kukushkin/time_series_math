require 'bundler/setup'
Bundler.setup

require 'time_series_math'

include TimeSeriesMath

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
