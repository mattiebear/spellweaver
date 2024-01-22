# frozen_string_literal: true

require 'securerandom'

FactoryBot.define do
  factory :access_user, class: 'Rogue::User' do
    id { "user_#{SecureRandom.hex}" }
    image_url { 'https://www.example.com/image' }

    sequence(:username) { |n| "user#{n}" }
  end
end
