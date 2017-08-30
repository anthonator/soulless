# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'soulless/version'

Gem::Specification.new do |spec|
  spec.name          = "soulless"
  spec.version       = Soulless::VERSION
  spec.authors       = ['Anthony Smith']
  spec.email         = ['anthony@sticksnleaves.com']

  spec.summary       = %q{Rails models without the database (and Rails)}
  spec.description   = %q{Create Rails style models without the database (and Rails).}
  spec.homepage      = 'https://github.com/anthonator/soulless'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'activemodel', '>= 4.2.0', '< 5.2'
  spec.add_dependency 'virtus' , '~> 1.0'

  spec.add_development_dependency 'bundler', '~> 0'
  spec.add_development_dependency 'rake', '~> 0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
