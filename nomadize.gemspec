# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nomadize/version'

Gem::Specification.new do |spec|
  spec.name          = "nomadize"
  spec.version       = Nomadize::VERSION
  spec.authors       = ["Paul Dawson"]
  spec.email         = ["paul@into.computer"]

  spec.summary       = %q{A simple database migration utility}
  spec.homepage      = "https://github.com/piisalie/nomadize"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"

  spec.add_dependency "pg", "~> 0.18.1"
end
