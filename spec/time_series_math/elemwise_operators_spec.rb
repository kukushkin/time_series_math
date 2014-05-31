require 'spec_helper'

describe 'ElemwiseOperators' do
  class A
  end

  subject { A.new.extend(ElemwiseOperators) }

  describe '#elemwise_add' do
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
    it 'should multiply Fixnum' do
      expect(subject.elemwise_mul_scalar( 2.0, 3.0 )).to eql 6.0
    end
    it 'should multiply Array(s)' do
      expect(subject.elemwise_mul_scalar(2.0, [3.0])).to eql [6.0]
    end
    it 'should mutiply Hash(es)' do
      expect(subject.elemwise_mul_scalar(2.0, { x: 3.0 })).to eql({ x: 6.0 })
    end
  end
end
