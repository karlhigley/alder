require 'active_support'
require 'active_support/core_ext/class/attribute'

module Alder
  class Mapping
    class_attribute :up_rules, :instance_writer => false
    class_attribute :down_rules, :instance_writer => false

    self.up_rules = []
    self.down_rules = []

    def self.inherited(subclass)
      subclass.up_rules += self.up_rules
      subclass.down_rules += self.down_rules
    end

    def self.up(fragment = {}, &transform)
      rule = Rule.new(fragment, &transform)
      self.up_rules << rule
    end

    def self.down(fragment = {}, &transform)
      rule = Rule.new(fragment, &transform)
      self.down_rules << rule
    end

    def self.mapping(mapping)
      self.up_rules += mapping.up_rules
      self.down_rules += mapping.down_rules
    end

    def initialize(up_t = up_transform, down_t = down_transform)
      @up = up_t
      @down = down_t
    end

    def up(hash)
      @up.apply(hash)
    end

    def down(hash)
      @down.apply(hash)
    end

    private

    def up_transform
      Transform.new(self.class.up_rules)
    end

    def down_transform
      Transform.new(self.class.down_rules.reverse)
    end
  end
end
