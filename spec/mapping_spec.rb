require 'spec_helper'

describe Alder::Mapping do
  context 'DSL' do
    class TestMapping < described_class
      up :key1 => :_ do |m|
        m[:key2] = m.delete(:key1).upcase
      end

      down :key2 => :_ do |m|
        m[:key1] = m.delete(:key2).downcase
      end
    end

    subject { TestMapping.new }

    it 'performs up transformations' do
      result = subject.up({key1: "value"})
      expect(result).to eq({key2: "VALUE"})
    end

    it 'performs down transformations' do
      result = subject.down({key2: "VALUE"})
      expect(result).to eq({key1: "value"})
    end

    context 'without matching fragments' do
      class UniversalMapping < described_class
        up do |m|
          m.keys.each do |k|
            m[k] = m.delete(k).upcase
          end
        end

        down do |m|
          m.keys.each do |k|
            m[k] = m.delete(k).downcase
          end
        end
      end

      subject { UniversalMapping.new }

      it 'applies up transformations everywhere' do
        result = subject.up({key1: "value1", key2: "value2"})
        expect(result).to eq({key1: "VALUE1", key2: "VALUE2"})
      end

      it 'applies down transformations everywhere' do
        result = subject.down({key1: "VALUE1", key2: "VALUE2"})
        expect(result).to eq({key1: "value1", key2: "value2"})
      end
    end

    context 'with nested hash fragments' do
      class NestedMapping < described_class
        up :keyA => {key1: :_} do |m|
          m[:keyB] = m.delete(:keyA)
        end
      end

      subject { NestedMapping.new }

      it 'performs transformations' do
        result = subject.up({keyA: {key1: "value"}})
        expect(result).to eq({keyB: {key1: "value"}})
      end
    end

    context 'with deeper inheritance hierarchy' do
      class InheritedMapping < TestMapping
        up :key2 => :_ do |m|
          m[:key2] += "!"
        end
      end

      subject { InheritedMapping.new }

      it 'adds to rules inherited from parent' do
        result = subject.up({key1: "value"})
        expect(result).to eq({key2: "VALUE!"})
      end
    end

    context 'with sub-mapping' do
      class ComposedMapping < described_class
        mapping TestMapping

        up :key2 => :_ do |m|
          m[:key2] += "!"
        end
      end

      subject { ComposedMapping.new }

      it 'adds to rules from sub-mapping' do
        result = subject.up({key1: "value"})
        expect(result).to eq({key2: "VALUE!"})
      end
    end

    context 'with several sub-mappings' do
      class ABMapping < described_class
        up :key => :_ do |m|
          m[:key].sub!('A', 'B')
        end

        down :key => :_ do |m|
          m[:key].sub!('B', 'A')
        end
      end

      class BCMapping < described_class
        up :key => :_ do |m|
          m[:key].sub!('B', 'C')
        end

        down :key => :_ do |m|
          m[:key].sub!('C', 'B')
        end
      end

      class CDMapping < described_class
        up :key => :_ do |m|
          m[:key].sub!('C', 'D')
        end

        down :key => :_ do |m|
          m[:key].sub!('D', 'C')
        end
      end

      class MultiComposedMapping < described_class
        mapping ABMapping
        mapping BCMapping
        mapping CDMapping
      end

      subject { MultiComposedMapping.new }

      it 'completes a round trip transformation' do
        hash = {key: 'A'}
        up_result = subject.up(hash)
        down_result = subject.down(up_result)
        expect(down_result).to eq(hash)
      end
    end
  end
end
