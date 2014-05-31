require 'spec_helper'

describe TimeSeries do
  it { should respond_to(:bsearch_indices_at) }
  it { expect { subject.bsearch_indices_at(1.0) }.not_to raise_error }
  it { expect(subject.bsearch_indices_at(1.0)).to eql [nil, nil] }

  let(:arr_t)   { [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0] }
  let(:arr_t1)  { [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0] }
  let(:arr_t2)  { [1.0, 1.0, 1.0, 2.0, 2.0, 2.0, 2.0] }
  let(:arr_v)   { [111, 222, 333, 444, 555, 666, 777] }

  context 'when initialized with arrays' do
    subject { TimeSeries.new(arr_t, arr_v) }

    describe '#bsearch_indices_at' do
      it 'should return [nil, 0] if t < first element' do
        expect(subject.bsearch_indices_at(-1.0)).to eql [nil, 0]
      end
      it 'should return [i_k, i_k+1] if T(i_k) <= t < T(i_k+1)' do
        expect(subject.bsearch_indices_at(1.0)).to eql [0, 1]
        expect(subject.bsearch_indices_at(1.5)).to eql [0, 1]
      end
      it 'should return last element index [N, nil] if T(N) <= t' do
        expect(subject.bsearch_indices_at(10.0)).to eql [6, nil]
      end
    end
  end

  context 'when initialized with several items with same timestamp' do
    let(:ts1) { TimeSeries.new(arr_t1, arr_v) }
    let(:ts2) { TimeSeries.new(arr_t2, arr_v) }

    describe '#bsearch_indices_at' do
      it 'should return last element index pair [N, nil] if T(N) <= t' do
        expect(ts1.bsearch_indices_at(1.0)).to eql [6, nil]
        expect(ts1.bsearch_indices_at(10.0)).to eql [6, nil]
      end
      it 'should return index pair of last element in serie of equal timestamps' do
        expect(ts2.bsearch_indices_at(1.0)).to eql [2, 3]
      end
    end
  end
end
