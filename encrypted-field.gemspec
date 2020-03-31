# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'encrypted-field'
  s.version     = '0.1.0'
  s.licenses    = ['MIT']
  s.summary     = 'Creates a simple interface for encrypting fields'
  s.description = 'Encrypt data using policies, designed with key rotation in mind'
  s.authors     = ['Doug Youch']
  s.email       = 'dougyouch@gmail.com'
  s.homepage    = 'https://github.com/dougyouch/encrypted-field'
  s.files       = Dir.glob('lib/**/*.rb')
end
