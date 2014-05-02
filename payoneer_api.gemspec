lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'payoneer_api/version'

Gem::Specification.new do |spec|
  spec.name = 'payoneer_api'
  spec.version = PayoneerApi::Version
  spec.date = '2014-05-02'
  spec.description = %q(Ruby wrapper for Payoneer API)
  spec.summary = spec.description
  spec.authors = ['Donald Piret']
  spec.email = %w[donald@donaldpiret.com]
  spec.files = %w[README.md payoneer_api.gemspec]
  spec.files += Dir.glob('lib/**/*.rb')
  spec.files += Dir.glob('spec/**/*')
  spec.licenses = %w[MIT]
  spec.require_paths = %w[lib]
  spec.required_rubygems_version = '>= 1.3.5'
  spec.test_files = Dir.glob('spec/**/*')
  spec.homepage    = 'https://github.com/donaldpiret/payoneer_api'

  spec.add_dependency 'nokogiri'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'dotenv'
  spec.add_development_dependency 'byebug'
end
