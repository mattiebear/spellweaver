# frozen_string_literal: true

FactoryBot.define do
  factory :connection_user do
    role { 'requester' }

    sequence(:user_id) { |n| "user_#{n}" }

    connection

    after(:build) do |player|
      player.user = build(:user, id: player.user_id)
    end
  end
end
