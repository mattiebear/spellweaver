# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: 'Rogue::User' do
    image_url { 'https://www.example.com/image' }

    sequence(:username) { |n| "user#{n}" }
    sequence(:id) { |n| "user_#{n}" }
  end
end
