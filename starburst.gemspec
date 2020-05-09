# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'starburst/version'

Gem::Specification.new do |spec|
  spec.name        = 'starburst'
  spec.version     = Starburst::VERSION
  spec.authors     = ['Corey Martin']
  spec.email       = ['coreym@gmail.com']

  spec.summary     = 'One-time messages to users in your app'
  spec.description = 'Show one-time messages to users in your Rails app'
  spec.homepage    = 'https://github.com/starburstgem/starburst'
  spec.license     = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = 'https://github.com/starburstgem/starburst/blob/master/CHANGELOG.md'

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rails', '>= 4.2.0', '< 6.1'

  spec.add_development_dependency 'appraisal', '2.2.0'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'capybara', '~> 3.32.1'
  spec.add_development_dependency 'factory_bot_rails'
  spec.add_development_dependency 'rspec-rails', '~> 4.0.0'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'sqlite3', '~> 1.4.1'
end
