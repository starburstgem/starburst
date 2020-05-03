# frozen_string_literal: true

module Starburst
  class Engine < ::Rails::Engine
    isolate_namespace Starburst

    config.generators do |g|
      g.test_framework :rspec, fixture: true
      g.fixture_replacement :factory_bot
      g.assets false
      g.helper false
    end
  end
end
