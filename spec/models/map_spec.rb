# frozen_string_literal: true

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
