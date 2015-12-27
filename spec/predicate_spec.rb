require 'spec_helper'

describe Alder::Predicate do
  let(:fragment)  { {key1: "value1"} }

  subject { described_class.new(fragment) }

  it 'matches fragment keys' do
    expect(subject).to match( {key1: "value1"} )
    expect(subject).not_to match( {key2: "value1"} )
  end

  it 'matches fragment values' do
    expect(subject).to match( {key1: "value1"} )
    expect(subject).not_to match( {key1: "value2"} )
  end

  context 'with value wildcard' do
    let(:fragment)  { {key1: :_} }    

    it 'matches :_ with all values' do
      expect(subject).to match( {key1: "value1"} )
      expect(subject).to match( {key1: "value2"} )
    end
  end

  context 'with key regex' do
    let(:fragment)  { {/key/ => "value1"} }

    it 'matches regex' do
      expect(subject).to match( {key1: "value1"} )
      expect(subject).to match( {key2: "value1"} )
      expect(subject).not_to match( {other: "value1"} )
    end
  end

  context 'with nested fragment' do
    context 'and value wildcard' do
      let(:fragment)  { {keyA: {key1: :_}} }

      it 'matches recursively' do
        expect(subject).to match( {keyA: {key1: "value1"}} )
        expect(subject).to match( {keyA: {key1: "value2"}} )
      end
    end

    context 'and key regex' do
      let(:fragment)  { {keyA: {/key1/ => "value1"}} }

      it 'matches regex' do
        expect(subject).to match( {keyA: {key1: "value1"}} )
        expect(subject).not_to match( {keyB: {key1: "value1"}} )
        expect(subject).not_to match( {keyA: {key2: "value1"}} )
        expect(subject).not_to match( {keyA: {key1: "value2"}} )
      end
    end
  end
end
