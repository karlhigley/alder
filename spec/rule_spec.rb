require 'spec_helper'

describe Alder::Rule do
  let(:fragment)  { {key1: "value1"} }
  let(:transform) { lambda { |m| m[:key1] = "value2"; m } }
  
  subject { described_class.new(fragment, &transform) }

  context 'with a match' do
    it 'applies transform' do
      match = fragment.dup
      subject.apply(match)
      expect(match).to eq({key1: "value2"})
    end
  end

  context 'without a match' do
    it 'does nothing' do
      non_match = {key2: "value2"}
      subject.apply(non_match)
      expect(non_match).to eq({key2: "value2"})
    end
  end
end
