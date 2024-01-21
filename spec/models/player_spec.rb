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
require 'rails_helper'

RSpec.describe Player do
  describe 'factory' do
    it 'has a valid factory' do
      player = build(:player)

      expect(player).to be_valid
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user_id) }
  end

  describe 'attributes' do
    it { is_expected.to define_enum_for(:role).with_values(participant: 0, owner: 1) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:game_session) }
  end
end
