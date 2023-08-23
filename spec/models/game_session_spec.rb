# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GameSession do
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
