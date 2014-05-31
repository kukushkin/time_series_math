require 'spec_helper'

describe TimeSeries do
  module TimeSeriesTestProcessor
  end

  it { should respond_to(:use) }
  it { should respond_to(:processor) }
  it { expect(subject.processor).to be nil }
  it { expect(subject.use(TimeSeriesTestProcessor)).to eql subject }

  context 'when using a processor' do
    subject { TimeSeries.new.use(TimeSeriesTestProcessor) }
    it { expect(subject.processor).to eql TimeSeriesTestProcessor }
  end
end
