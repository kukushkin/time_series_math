require 'spec_helper'

describe LinearInterpolation do

  let(:arr_t) { [1.0, 2.0, 3.0] }
  let(:arr_v) { [100, 200, 300] }
  let(:arr_v_a) { [[100], [200], [300]] }
  let(:arr_v_h) { [{ x: 100 }, { x: 200 }, { x: 300 }] }
  it { expect { TimeSeries.new.use(LinearInterpolation) }.to_not raise_error }

  context 'when values are floats' do
    subject { TimeSeries.new(arr_t, arr_v).use(LinearInterpolation) }
    it { expect(subject[1.5]).to eql 150.to_f }
  end

  context 'when values are arrays' do
    subject { TimeSeries.new(arr_t, arr_v_a).use(LinearInterpolation) }
    it { expect(subject[1.5]).to eql [150.to_f] }
  end

  context 'when values are hashes' do
    subject { TimeSeries.new(arr_t, arr_v_h).use(LinearInterpolation) }
    it { expect(subject[1.5]).to eql({ x: 150.to_f }) }
  end

end
