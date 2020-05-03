# frozen_string_literal: true

FactoryBot.define do
  factory :announcement, class: Starburst::Announcement do
    body { 'Announcement text' }
  end
end
