# frozen_string_literal: true

# == Schema Information
#
# Table name: game_players
#
#  id         :uuid             not null, primary key
#  role       :integer          default("participant")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  session_id :uuid             not null
#  user_id    :string           not null
#
# Indexes
#
#  index_game_players_on_session_id  (session_id)
#  index_game_players_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (session_id => game_sessions.id)
#
module Game
  class Player < ApplicationRecord
    include Ownable

    belongs_to :session, class_name: 'Game::Session'

    enum role: {
      participant: 0,
      owner: 1
    }
  end
end
