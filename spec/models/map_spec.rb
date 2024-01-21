# frozen_string_literal: true

# == Schema Information
#
# Table name: maps
#
#  id         :uuid             not null, primary key
#  atlas      :json             not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :string           not null
#
# Indexes
#
#  index_maps_on_user_id           (user_id)
#  index_maps_on_user_id_and_name  (user_id,name) UNIQUE
#
require 'rails_helper'

RSpec.describe Map do
  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_length_of(:name).is_at_least(1).is_at_most(250) }

    it { is_expected.to validate_presence_of :user_id }

    it 'validates user id format' do
      map = build(:map, user_id: 'blah')

      map.validate

      expect(map.errors[:user_id]).to include('is not a valid user id')
    end

    it { is_expected.to validate_presence_of :atlas }

    it 'validates atlas format' do
      map = build(:map, atlas: [])

      map.validate

      expect(map.errors[:atlas]).to include('is not a valid atlas')
    end
  end
end
