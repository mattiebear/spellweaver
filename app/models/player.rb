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
class Player < ApplicationRecord
  include Ownable

  belongs_to :game_session

  enum role: {
    participant: 0,
    owner: 1
  }
end
