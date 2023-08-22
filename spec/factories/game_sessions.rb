# frozen_string_literal: true

FactoryBot.define do
  factory :game_session do
    status { 'pending' }
    name { 'Game Session' }
  end
end
