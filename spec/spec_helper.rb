require 'bundler/setup'
Bundler.setup

require 'payoneer_api'
require 'vcr'
require 'webmock'
require 'nokogiri'
require 'byebug'
require 'dotenv'
Dotenv.load

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
end