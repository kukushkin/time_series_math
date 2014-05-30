require 'spec_helper'

describe TimeSeries do
  context 'when empty' do
    subject { TimeSeries.new }
    it { expect(subject.data).to eql [] }
    it { expect(subject.first).to be nil }
    it { expect(subject.last).to be nil }
    it { expect(subject.t_first).to be nil }
    it { expect(subject.t_last).to be nil }
    it { expect(subject.size).to eql 0 }
    it { expect(subject.keys).to eql [] }
    it { expect(subject.values).to eql [] }
    it { expect(subject.left_index_at(1.0)).to be nil }
  end

  let(:arr_t) { [1.0, 2.0, 3.0] }
  let(:arr_v) { [111, 222, 333] }
  it { expect { TimeSeries.new(arr_t, arr_v) }.to_not raise_error }

  context 'when initialized with arrays' do
    subject { TimeSeries.new(arr_t, arr_v) }
    it { expect(subject.size).to eql 3 }
    it { expect(subject.first).to eql [1.0, 111] }
    it { expect(subject.last).to eql [3.0, 333] }
    it { expect(subject.t_first).to eql 1.0 }
    it { expect(subject.t_last).to eql 3.0 }

    describe '#left_index_at' do
      it 'should return nil if t < first element' do
        expect(subject.left_index_at(-1.0)).to be nil
      end
      it 'should return i_k if T(i_k) <= t < T(i_k+1)' do
        expect(subject.left_index_at(1.0)).to be 0
        expect(subject.left_index_at(1.5)).to be 0
      end
      it 'should return last element index (N) if T(N) <= t' do
        expect(subject.left_index_at(10.0)).to be 2
      end
    end
  end

  context 'when adding new items' do
    subject { TimeSeries.new(arr_t, arr_v) }
    it 'should place new items at correct place' do
      expect { subject.push(1.5, 123) }.to_not raise_error
      expect(subject.keys).to eql [1.0, 1.5, 2.0, 3.0]
    end
  end

end
