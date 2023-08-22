# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rogue::User do
  describe 'factory' do
    it 'has a valid factory' do
      user = build(:user)

      expect(user).to be_valid
    end
  end
end
