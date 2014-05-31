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
    it { expect(subject.indices_at(1.0)).to eql [nil, nil] }
    it { expect(subject[1.0]).to be nil }
  end

  let(:arr_t)   { [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0] }
  let(:arr_t1)  { [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0] }
  let(:arr_t2)  { [1.0, 1.0, 1.0, 2.0, 2.0, 2.0, 2.0] }
  let(:arr_v)   { [111, 222, 333, 444, 555, 666, 777] }
  it { expect { TimeSeries.new(arr_t, arr_v) }.to_not raise_error }

  context 'when initialized with arrays' do
    subject { TimeSeries.new(arr_t, arr_v) }
    it { expect(subject.size).to eql 7 }
    it { expect(subject.first).to eql [1.0, 111] }
    it { expect(subject.last).to eql [7.0, 777] }
    it { expect(subject.t_first).to eql 1.0 }
    it { expect(subject.t_last).to eql 7.0 }

    describe '#left_index_at' do
      it 'should return nil if t < first element' do
        expect(subject.left_index_at(-1.0)).to be nil
      end
      it 'should return i_k if T(i_k) <= t < T(i_k+1)' do
        expect(subject.left_index_at(1.0)).to be 0
        expect(subject.left_index_at(1.5)).to be 0
      end
      it 'should return last element index (N) if T(N) <= t' do
        expect(subject.left_index_at(10.0)).to be 6
      end
    end

    describe '#[]' do
      it 'should return nil if t < first element' do
        expect(subject[-1.0]).to be nil
      end
      it 'should return i_k if T(i_k) <= t < T(i_k+1)' do
        expect(subject[1.0]).to be 111
        expect(subject[1.5]).to be 111
      end
      it 'should return last element index (N) if T(N) <= t' do
        expect(subject[10.0]).to be 777
      end
    end
  end

  context 'when initialized with several items with same timestamp' do
    let(:ts1) { TimeSeries.new(arr_t1, arr_v) }
    let(:ts2) { TimeSeries.new(arr_t2, arr_v) }

    describe '#left_index_at' do
      it 'should return last element index (N) if T(N) <= t' do
        expect(ts1.left_index_at(1.0)).to be 6
        expect(ts1.left_index_at(10.0)).to be 6
      end
      it 'should return index of last element in serie of equal timestamps' do
        expect(ts2.left_index_at(1.0)).to be 2
      end
    end

    describe '#indices_at' do
      it 'should return last element index pair [N, nil] if T(N) <= t' do
        expect(ts1.indices_at(1.0)).to eql [6, nil]
        expect(ts1.indices_at(10.0)).to eql [6, nil]
      end
      it 'should return index pair of last element in serie of equal timestamps' do
        expect(ts2.indices_at(1.0)).to eql [2, 3]
      end
    end
  end

  context 'when adding new items' do
    subject { TimeSeries.new(arr_t, arr_v) }
    it 'should place new items at correct place' do
      expect { subject.push(1.5, 123) }.to_not raise_error
      expect(subject.keys).to eql [1.0, 1.5, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0]
    end
    it 'should allow []= syntax' do
      expect { subject[1.5] = 123 }.to_not raise_error
      expect(subject.keys).to eql [1.0, 1.5, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0]
    end
  end

end
