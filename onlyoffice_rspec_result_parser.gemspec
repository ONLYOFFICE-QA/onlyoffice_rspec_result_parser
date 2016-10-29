# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'onlyoffice_rspec_result_parser/version'

Gem::Specification.new do |spec|
  spec.name          = 'onlyoffice_rspec_result_parser'
  spec.version       = OnlyofficeRspecResultParser::VERSION
  spec.authors       = ['Pavel Lobashov', 'Ivan Tugin']
  spec.email         = ['shockwavenn@gmail.com']

  spec.summary       = 'Gem to parse rspec results'
  spec.description   = 'Gem to parse rspec results. Needed in wrata project'
  spec.homepage      = 'https://github.com/onlyoffice-testing-robot/onlyoffice_rspec_result_parser'

  spec.files = `git ls-files lib LICENSE.txt README.md`.split($RS)

  spec.add_runtime_dependency('nokogiri', '~> 1.6')
  spec.license = 'AGPL-3.0'
end
