# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'digitalfilmtree/version'

Gem::Specification.new do |spec|
  spec.name          = "digitalfilmtree"
  spec.version       = Digitalfilmtree::VERSION
  spec.authors       = ["Keyvan Fatehi"]
  spec.email         = ["keyvan@digitalfilmtree.com"]
  spec.description   = %q{Assorted libraries for DigitalFilm Tree post workflow}
  spec.summary       = %q{Assorted libraries for DigitalFilm Tree post workflow}
  spec.homepage      = "https://github.com/DFTi/digitalfilmtree"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/).reject{|i| i.match(/spec\/fixtures/) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "simplecov"

	spec.add_runtime_dependency "pry"
  spec.add_runtime_dependency "digitalfilmtree-util"
  spec.add_runtime_dependency "edl", "~> 0.1.3"
end
