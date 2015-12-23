require 'active_support'
require 'active_support/core_ext/object/deep_dup'

module Alder
  class Transform
    def initialize(rules)
      @rules = rules
    end

    def apply(hash)
      transform(hash.deep_dup)
    end

    alias_method :call, :apply

    private

    def transform(hash)
      descend_into(hash)
      apply_rules(@rules, hash)
    end

    def descend_into(hash)
      hash.each_with_object(hash) do |(key, value), result|
        case
        when value.is_a?(Hash)
          result[key] = transform(value)
        when value.is_a?(Array)
          result[key] = value.map { |v| transform(v) }
        end
        result
      end
    end

    def apply_rules(rules, hash)
      rules.each_with_object(hash) do |rule, result|
        rule.apply(result)
      end
    end
  end
end
