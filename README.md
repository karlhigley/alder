# alder [![Gem Version](https://badge.fury.io/rb/alder.svg)](https://badge.fury.io/rb/alder) [![Build Status](https://travis-ci.org/karlhigley/alder.svg?branch=master)](https://travis-ci.org/karlhigley/alder)

A Ruby library for transforming hashes

## Motivation

Sometimes back-end services return aggregates that contain essentially the same information that existing domain models use, but in a slightly different format. It would be nice to be able to easily transform that data into a format compatible with existing models (e.g. ActiveRecord models that use accepts_nested_attributes_for).

## Usage

Mappings represent bidirectional hash transformations. The `Mapping` class provides a simple DSL, with `up`, `down`, and `mapping` methods.

By convention, the `up` transformation converts a hash into the form expected by Ruby domain classes, while the `down` transformation converts a hash into the form expected by data stores or serialization formats.

```ruby
class KeyMapping < Alder::Mapping
  # Key matching supports literals and regular expressions
  up /key1/ => "value1" do |match|
    match[:key3] = match.delete(:key1)
  end

  # Value matching supports literal and wildcard values (:_)
  down /key3/ => :_ do |match|
    match[:key1] = match.delete(:key3)
  end
end
```

Mappings can be composed with the `mapping` method, which includes the transformations defined on another mapping class:

```ruby
class ExampleMapping < Alder::Mapping
  mapping KeyMapping

  up :key3 => :_ do |match|
  	match[:key3] += " is now value3"
  end

  down :key3 => :_ do |match|
  	match[:key3].sub!(" is now value3", "")
  end
end
```

 (Alternately, the `up` and `down` DSL methods may each be called multiple times in a single class to define a series of transformations.)

Mappings operate on deep copies to avoid mutating the supplied hash parameter:

```ruby
mapping = ExampleMapping.new
hash = {keyA: {key1: "value1", key2: "value2"}}

mapping.up(hash)
#=> {:keyA=>{:key2=>"value2", :key3=>"value1 is now value3"}}

hash
#=> {:keyA=>{:key1=>"value1", :key2=>"value2"}}
```
