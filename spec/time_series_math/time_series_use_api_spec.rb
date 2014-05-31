require 'spec_helper'

describe TimeSeries do
  it { should respond_to(:use) }
  it { should respond_to(:processor) }
  it { expect(subject.processor).to be nil }
  it { expect(subject.use(LinearInterpolation)).to eql subject }

  context 'when using a processor' do
    subject { TimeSeries.new.use(LinearInterpolation) }
    it { expect(subject.processor).to eql LinearInterpolation }
  end
end
