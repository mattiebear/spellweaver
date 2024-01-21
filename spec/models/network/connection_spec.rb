# frozen_string_literal: true

# == Schema Information
#
# Table name: connections
#
#  id         :uuid             not null, primary key
#  status     :integer          default("pending")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Network::Connection do
  describe 'factory' do
    it 'has a valid factory' do
      connection = build(:network_connection)

      expect(connection).to be_valid
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:users).dependent(:destroy) }
  end

  describe 'attributes' do
    it { is_expected.to define_enum_for(:status).with_values(pending: 0, accepted: 1) }
  end
end
