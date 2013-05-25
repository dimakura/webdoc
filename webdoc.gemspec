# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'webdoc/version'

Gem::Specification.new do |spec|
  spec.name          = "webdoc"
  spec.version       = Webdoc::VERSION
  spec.authors       = ["Dimitri Kurashvili"]
  spec.email         = ["dimakura@gmail.com"]
  spec.description   = %q{easy webapp documentation}
  spec.summary       = %q{easy webapp documentation}
  spec.homepage      = "http://github.com/dimakura/webdoc"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
