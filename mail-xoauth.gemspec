# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mail/xoauth/version'

Gem::Specification.new do |spec|
  spec.name          = "mail-xoauth"
  spec.version       = Mail::Xoauth::VERSION
  spec.authors       = ["ahawkins"]
  spec.email         = ["me@broadcastingadam.com"]
  spec.description   = %q{TODO: Write a gem description}
  spec.summary       = %q{TODO: Write a gem summary}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'mail'
  spec.add_dependency 'gmail_xoauth'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "faraday"
  spec.add_development_dependency "faraday_middleware"
end
