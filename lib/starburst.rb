# frozen_string_literal: true

require 'starburst/engine'

module Starburst
  mattr_accessor :current_user_method do
    :current_user
  end

  mattr_accessor :user_instance_methods do
    nil
  end

  def self.configuration
    yield self
  end
end
