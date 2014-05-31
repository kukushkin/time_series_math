$LOAD_PATH.unshift '../lib'
require 'time_series_math'
require 'benchmark'

include TimeSeriesMath

def t_rand
  rand * 1000.0
end

def b_search(ts, t)
  return nil if t < ts.t_first
  return ts.last if t >= ts.t_last
  ileft = 0
  iright = ts.size-1
  while iright - ileft > 1
    icenter = ileft + (iright - ileft) /2
    if t >= ts.data[icenter][0]
      ileft = icenter
    else
      iright = icenter
    end
  end
  if iright - ileft != 1
    fail "ileft:#{ileft} iright:#{iright}"
  elsif ts.data[ileft][0] > t || ts.data[iright][0] <= t
    puts "(ts: t_first:#{ts.t_first} t_last:#{ts.t_last}"
    fail "t:#{t}, t_left:#{ts.data[ileft][0]}, t_right:#{ts.data[iright][0]}"
  end
  v = ts.data[ileft]
end

def b_search_native(ts, t)
  v_right = ts.data.bsearch { |d| d[0] > t }
  v_right.nil? ? ts.last : v_right[1]
end

TS_N = [1_000, 100_000, 1_000_000]
TESTS = 1000_000
ts_list = []

TS_N.each do |num_samples|
  puts "** initializing time series with #{num_samples} samples"
  tt = []
  dd = []
  num_samples.times do
    tt << t_rand
    dd << { x: rand * 10.0 }
  end
  ts_list << TimeSeries.new(tt, dd)
end

puts '** running benchmarks'
Benchmark.bmbm do |b|
  ts_list.each do |ts|
    b.report "size: #{ts.size}, running #{TESTS} times #indices_at" do
      TESTS.times { ts.indices_at(t_rand) }
    end
  end
  ts_list.each do |ts|
    b.report "size: #{ts.size}, running #{TESTS} times #bsearch_indices_at" do
      TESTS.times { ts.bsearch_indices_at(t_rand) }
    end
  end
  ts_list.each do |ts|
    b.report "size: #{ts.size}, running #{TESTS} times #b_search" do
      TESTS.times { b_search(ts, t_rand) }
    end
  end
  ts_list.each do |ts|
    b.report "size: #{ts.size}, running #{TESTS} times #b_search_native" do
      TESTS.times { b_search_native(ts, t_rand) }
    end
  end
end
