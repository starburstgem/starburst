$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "starburst/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "starburst"
  s.version     = Starburst::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Starburst."
  s.description = "TODO: Description of Starburst."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  
  s.add_dependency "rails", "~> 4.1.4"

  s.add_development_dependency "sqlite3"

  #RSpec
  s.test_files = Dir["spec/**/*"]
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "capybara"
  s.add_development_dependency "selenium-webdriver"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "faker"
end
