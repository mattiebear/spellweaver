# frozen_string_literal: true

FactoryBot.define do
  factory :player do
    role { 'participant' }

    sequence(:user_id) { |n| "user_#{n}" }

    game_session

    after(:build) do |player|
      player.user = build(:user, id: player.user_id)
    end
  end
end
