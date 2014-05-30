require 'spec_helper'

describe TimeSeries do
  context 'when empty' do
    subject { TimeSeries.new }
    it { expect(subject.data).to eql [] }
    it { expect(subject.first).to be nil }
    it { expect(subject.last).to be nil }
    it { expect(subject.t_first).to be nil }
    it { expect(subject.t_last).to be nil }
  end
end
