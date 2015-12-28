require 'spec_helper'

describe "Alder Smoke Tests" do
  class AggregateMapping < Alder::Mapping
    def self.split_key(key)
      key.to_s.split(".").map(&:to_sym)
    end

    def self.build_slice(layers, value)
      layers.reverse.inject(value) do |result, layer|
        {layer => result}
      end
    end

    up /\./ => :_ do |m|
      m.keys.each do |k|
        layers = split_key(k)
        new_slice = build_slice(layers, m.delete(k))
        m.deep_merge!(new_slice)
      end
    end

    down do |m|      
      m.keys.each do |k|
        if m[k].is_a?(Hash)
          value = m.delete(k)
          value.keys.each do |vk|
            new_key = [k.to_s, vk.to_s].join(".").to_sym
            m[new_key] = value[vk]
          end
        end
      end
    end
  end

  subject { AggregateMapping.new }

  let(:aggregate_hash) {
    {
      :aggregate=>{
        :prop1=>"1a",
        :prop2=>"2a",
        :leaves=>[
          {propA: "A1", propB: "B1"},
          {propA: "A2", propB: "B2"}
        ]
      }
    }
  }

  let(:source_hash) {
    {
      :'aggregate.prop1' => "1a",
      :'aggregate.prop2' => "2a",
      :'aggregate.leaves' => [
          {propA: "A1", propB: "B1"},
          {propA: "A2", propB: "B2"}
        ]
    }
  }

  it 'transforms aggregate hash into source hash' do
    result = subject.down(aggregate_hash)
    expect(result).to eq(source_hash)
  end

  it 'transforms source hash into aggregate hash' do
    result = subject.up(source_hash)
    expect(result).to eq(aggregate_hash)
  end
end