Gem::Specification.new do |s|
  s.name        = 'payoneer_api'
  s.version     = '0.0.1'
  s.date        = '2013-05-30'
  s.summary     = 'Ruby wrapper for Payoneer API'
  s.description = 'Allows to easily generate the links for Pioneer registration'
  s.authors     = ['Donald Piret']
  s.email       = 'ejabberd@gmail.com'
  s.files       = ['lib/payoneer_api/client.rb', 'lib/payoneer_api/payoneer_exception.rb']
  s.homepage    = 'https://github.com/roomorama/payoneer_api'

  s.add_dependency 'nokogiri'

  s.add_development_dependency 'rspec'
end
