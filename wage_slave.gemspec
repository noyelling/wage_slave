# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wage_slave/version'

Gem::Specification.new do |spec|
  spec.name          = "wage_slave"
  spec.version       = WageSlave::VERSION
  spec.authors       = ["James Gemmell", "Jasper Boyschau"]
  spec.email         = ["dev@noyelling.com.au"]

  spec.summary       = %q{Generate ABA, NZ-DE and IB4B direct entry files.}
  spec.description   = %q{A toolkit for generating and working with bulk payment files in various banking formats.}
  spec.homepage      = "http://github.com/noyelling/wage_slave"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "mocha", "~> 1.1"
  spec.add_development_dependency "dotenv", "~> 2.1"
  spec.add_development_dependency "minitest-reporters", "~> 1.1"
end
