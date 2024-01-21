# frozen_string_literal: true

# == Schema Information
#
# Table name: players
#
#  id              :uuid             not null, primary key
#  role            :integer          default("participant")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  game_session_id :uuid             not null
#  user_id         :string           not null
#
# Indexes
#
#  index_players_on_game_session_id  (game_session_id)
#  index_players_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (game_session_id => game_sessions.id)
#
FactoryBot.define do
  factory :game_player, class: 'Game::Player' do
    role { 'participant' }

    sequence(:user_id) { |n| "user_#{n}" }

    session { association :game_session }

    after(:build) do |player|
      player.user = build(:access_user, id: player.user_id)
    end
  end
end
