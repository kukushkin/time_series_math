require 'spec_helper'

describe SimpleInterpolatedTimeSeries do

  let(:arr_t) { [1.0, 2.0, 3.0] }
  let(:arr_v) { [100, 200, 300] }
  let(:arr_v_a) { [[100], [200], [300]] }
  let(:arr_v_h) { [{ x: 100 }, { x: 200 }, { x: 300 }] }
  it { expect { described_class.new(arr_t, arr_v) }.to_not raise_error }

  context 'when initialized with arrays' do
    subject { described_class.new(arr_t, arr_v) }
    it { expect(subject[1.5]).to eql 150.to_f }
  end

  context 'when values are arrays' do
    subject { described_class.new(arr_t, arr_v_a) }
    it { expect(subject[1.5]).to eql [150.to_f] }
  end

  context 'when values are hashes' do
    subject { described_class.new(arr_t, arr_v_h) }
    it { expect(subject[1.5]).to eql({ x: 150.to_f }) }
  end

  describe '#elemwise_add' do
    subject { described_class.new }
    it 'should add Fixnum' do
      expect(subject.elemwise_add( 1.0, 2.0 )).to eql 3.0
    end
    it 'should add Array(s)' do
      expect(subject.elemwise_add([1.0], [2.0])).to eql [3.0]
    end
    it 'should add Hash(es)' do
      expect(subject.elemwise_add({ x: 1.0 }, { x: 2.0 })).to eql({ x: 3.0 })
    end
  end

  describe '#elemwise_sub' do
    subject { described_class.new }
    it 'should substract Fixnum' do
      expect(subject.elemwise_sub( 1.0, 2.0 )).to eql -1.0
    end
    it 'should substract Array(s)' do
      expect(subject.elemwise_sub([1.0], [2.0])).to eql [-1.0]
    end
    it 'should substract Hash(es)' do
      expect(subject.elemwise_sub({ x: 1.0 }, { x: 2.0 })).to eql({ x: -1.0 })
    end
  end

  describe '#elemwise_mul_scalar' do
    subject { described_class.new }
    it 'should multiply Fixnum' do
      expect(subject.elemwise_mul_scalar( 2.0, 2.0 )).to eql 4.0
    end
    it 'should multiply Array(s)' do
      expect(subject.elemwise_mul_scalar(2.0, [2.0])).to eql [4.0]
    end
    it 'should mutiply Hash(es)' do
      expect(subject.elemwise_mul_scalar(2.0, { x: 2.0 })).to eql({ x: 4.0 })
    end
  end
end
