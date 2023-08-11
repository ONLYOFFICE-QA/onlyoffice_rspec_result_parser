# frozen_string_literal: true

require_relative 'lib/onlyoffice_rspec_result_parser/version'

Gem::Specification.new do |s|
  s.name = OnlyofficeRspecResultParser::NAME
  s.version = OnlyofficeRspecResultParser::VERSION
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.7'
  s.authors = ['ONLYOFFICE', 'Pavel Lobashov', 'Ivan Tugin']
  s.email = %w[shockwavenn@gmail.com]
  s.summary = 'Gem to parse rspec results'
  s.description = 'Gem to parse rspec results. Needed in wrata project'
  s.homepage = "https://github.com/ONLYOFFICE-QA/#{s.name}"
  s.metadata = {
    'bug_tracker_uri' => "#{s.homepage}/issues",
    'changelog_uri' => "#{s.homepage}/blob/master/CHANGELOG.md",
    'documentation_uri' => "https://www.rubydoc.info/gems/#{s.name}",
    'homepage_uri' => s.homepage,
    'source_code_uri' => s.homepage,
    'rubygems_mfa_required' => 'true'
  }
  s.files = Dir['lib/**/*']
  s.license = 'AGPL-3.0'
  s.add_runtime_dependency('nokogiri', '~> 1.6')
end
