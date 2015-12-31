module Alder
  class Predicate
    def initialize(fragment)
      @fragment = fragment
    end

    def match(hash)
      node_match(@fragment, hash)
    end

    private

    def node_match(fragment, hash)
      fragment.all? do |f_key, f_value|
        keys = key_match(f_key, hash)
        next false if keys.empty?

        values = value_match(f_value, keys, hash)
        !values.empty?
      end
    end

    def key_match(key, hash)
      matches = []
      if key.is_a?(Regexp)
        hash.keys.each do |k|
          matches << k if key =~ k
        end
      else
        matches << key if hash.has_key?(key)
      end
      matches
    end

    def value_match(value, keys, hash)
      matches = []
      keys.each do |k|
        v = hash[k]
        if value == :_ || value == v
          matches << v
        elsif v.is_a?(Hash) && node_match(value, v)
          matches << v
        end
      end
      matches
    end
  end
end
