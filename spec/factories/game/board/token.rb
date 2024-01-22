# frozen_string_literal: true

FactoryBot.define do
  factory :game_board_token, class: 'Game::Board::Token' do
    id { SecureRandom.uuid }
    pos { association :game_board_position }
    token_id { SecureRandom.uuid }
    user_id { SecureRandom.uuid }
  end
end
