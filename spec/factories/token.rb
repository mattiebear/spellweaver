# frozen_string_literal: true

FactoryBot.define do
  factory :token, class: 'Game::Token' do
    id { SecureRandom.uuid }
    pos { association :position }
    token_id { SecureRandom.uuid }
    user_id { SecureRandom.uuid }
  end
end
