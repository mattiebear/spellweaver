# frozen_string_literal: true

# == Schema Information
#
# Table name: game_sessions
#
#  id         :uuid             not null, primary key
#  name       :string
#  status     :integer          default("pending")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Game::Session do
  describe 'factory' do
    it 'has a valid factory' do
      game_session = build(:game_session)

      expect(game_session).to be_valid
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:players).dependent(:destroy) }
  end

  describe 'attributes' do
    it { is_expected.to define_enum_for(:status).with_values(pending: 0, active: 1, complete: 2) }
  end

  describe 'validations' do
    it { is_expected.to validate_length_of(:name).is_at_most(100) }
  end
end
