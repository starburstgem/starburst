# frozen_string_literal: true

SimpleCov.start :rails do
  add_filter File.join('lib', 'starburst', 'version.rb')
end
