# -*- encoding: utf-8 -*-
require File.expand_path('../lib/motion_json_decoder/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "motion-json-decoder"
  gem.authors       = ["Andy Waite"]
  gem.email         = ["andy@andywaite.com"]
  gem.description   = "Turn JSON nodes into rich Ruby objects"
  gem.summary       = "JSON decoder for RubyMotion"
  gem.homepage      = "https://github.com/andyw8/motion-json-decoder"

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.version       = Motion::JSONDecoder::VERSION
  gem.add_development_dependency 'rspec'
end
