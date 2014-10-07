$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "starburst/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "starburst"
  s.version     = Starburst::VERSION
  s.authors     = ["Corey Martin"]
  s.email       = ["coreym@gmail.com"]
  s.homepage    = "http://github.com/csm123/starburst"
  s.summary     = "One-time messages to users in your app"
  s.description = "Starburst allows you to show messages to logged in users within your Rails app. Once the user closes the message, they won't see it again."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  
  s.add_dependency "rails", ">= 3.0"

  s.add_development_dependency "sqlite3"

  #RSpec
  s.test_files = Dir["spec/**/*"]
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "capybara"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "appraisal"
end
