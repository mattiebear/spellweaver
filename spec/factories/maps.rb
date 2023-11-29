# frozen_string_literal: true

FactoryBot.define do
  factory :map do
    atlas { { version: '1', data: {} } }

    sequence(:user_id) { |n| "user_#{n}" }
    sequence(:name) { |n| "Map #{n}" }
  end
end
