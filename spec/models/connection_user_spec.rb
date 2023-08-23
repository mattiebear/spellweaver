# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConnectionUser do
  describe 'factory' do
    it 'has a valid factory' do
      connection_user = build(:connection_user)

      expect(connection_user).to be_valid
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user_id) }
  end

  describe 'attributes' do
    it { is_expected.to define_enum_for(:role).with_values(requester: 0, recipient: 1) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:connection) }
  end
end
