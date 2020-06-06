# frozen_string_literal: true

class User < ActiveRecord::Base
  def free?
    subscription.blank?
  end
end
