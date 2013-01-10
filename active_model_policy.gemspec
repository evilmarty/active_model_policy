# -*- encoding: utf-8 -*-
require File.expand_path('../lib/active_model/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Marty Zalega"]
  gem.email         = ["marty@zalega.me"]
  gem.description   = %q{Policy implementation for rails}
  gem.summary       = %q{Policy implementation for rails}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "active_model_policy"
  gem.require_paths = ["lib"]
  gem.version       = ActiveModel::Policy::VERSION

  gem.add_development_dependency "rails", ">= 3.0"
end
