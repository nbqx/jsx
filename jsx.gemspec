# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jsx/version'

Gem::Specification.new do |spec|
  spec.name          = "jsx"
  spec.version       = Jsx::VERSION
  spec.authors       = ["nbqx"]
  spec.email         = ["nbqxnbq@gmail.com"]
  spec.description   = %q{execute adobe extendscript from ruby, with preprocessor}
  spec.summary       = %q{execute adobe extendscript from ruby, with preprocessor}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "rspec", "~> 2.0"

  spec.add_dependency "sprockets", "~> 2.2.0"
  spec.add_dependency "sinatra"
  spec.add_dependency "json"
end
