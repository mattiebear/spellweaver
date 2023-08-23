# frozen_string_literal: true

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
