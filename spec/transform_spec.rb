require 'spec_helper'

describe Alder::Transform do
  let(:fragment)  { {key1: "value1"} }
  let(:transform) { lambda { |m| m[:key1] = "value2" } }
  let(:rule)      { Alder::Rule.new(fragment, &transform) }

  subject { described_class.new([rule]) }

  it 'leaves original hashes unchanged' do
    hash = {key1: "value1"}
    subject.apply(hash)
    expect(hash).to eq({key1: "value1"})
  end

  it 'applies simple rules' do
    result = subject.apply({key1: "value1"})
    expect(result).to eq({key1: "value2"})
  end

  it 'only applies rule transforms to matches' do
    result = subject.apply({key3: "value3"})
    expect(result).to eq({key3: "value3"})
  end

  it 'applies rules recursively' do
    result = subject.apply({keyA: {key1: "value1"}})
    expect(result).to eq({keyA: {key1: "value2"}})
  end

  it 'descends into arrays' do
    result = subject.apply({keyA: [{key1: "value1"}]})
    expect(result).to eq({keyA: [{key1: "value2"}]})
  end

  context 'with multiple rules' do
    let(:fragment)   { {key1: :_} }
    let(:transform1) { lambda { |m| m[:key1] += "value2" } }
    let(:transform2) { lambda { |m| m } }
    let(:rule1)       { Alder::Rule.new(fragment, &transform1) }
    let(:rule2)       { Alder::Rule.new(fragment, &transform2) }

    subject { described_class.new([rule1, rule2]) }

    it 'only applies each rule once to each match' do
      result = subject.apply({keyA: [{key1: ""}]})
      expect(result).to eq({keyA: [{key1: "value2"}]})
    end
  end
end
