# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alder/version'

Gem::Specification.new do |spec|
  spec.name          = "alder"
  spec.version       = Alder::VERSION
  spec.authors       = ["Karl Higley"]
  spec.email         = ["kmhigley@gmail.com"]

  spec.summary       = %q{A library for transforming hashes}
  spec.homepage      = "https://github.com/karlhigley/alder"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "~> 4.0"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
