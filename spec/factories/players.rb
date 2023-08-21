# frozen_string_literal: true

FactoryBot.define do
  factory :player do
    role { 1 }
    game_session { nil }
    user_id { 'MyString' }
  end
end
