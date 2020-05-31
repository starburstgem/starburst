# frozen_string_literal: true

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do # rubocop:disable RSpec/HookArgument
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, type: :feature) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do # rubocop:disable RSpec/HookArgument
    DatabaseCleaner.start
  end

  config.append_after(:each) do # rubocop:disable RSpec/HookArgument
    DatabaseCleaner.clean
  end
end
