Gem::Specification.new do |s|
  s.name        = 'payoneer_api'
  s.version     = '0.0.1'
  s.date        = '2014-05-02'
  s.summary     = 'Ruby wrapper for Payoneer API'
  s.description = 'Allows to easily generate the links for Pioneer registration'
  s.authors     = ['Donald Piret']
  s.email       = 'donald@donaldpiret.com'
  s.files       = ['lib/payoneer_api/client.rb', 'lib/payoneer_api/payoneer_exception.rb']
  s.homepage    = 'https://github.com/roomorama/payoneer_api'

  s.add_dependency 'nokogiri'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'dotenv'
  s.add_development_dependency 'byebug'
end
