# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Connection do
  describe 'factory' do
    it 'has a valid factory' do
      connection = build(:connection)

      expect(connection).to be_valid
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:connection_users).dependent(:destroy) }
  end

  describe 'attributes' do
    it { is_expected.to define_enum_for(:status).with_values(pending: 0, accepted: 1) }
  end
end
