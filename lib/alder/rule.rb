module Alder
  class Rule
    def initialize(fragment, &block)
      @predicate = Predicate.new(fragment)
      @transform = block
    end

    def apply(hash)
      @transform.call(hash) if @predicate.match(hash)
    end

    alias_method :call, :apply
  end
end
