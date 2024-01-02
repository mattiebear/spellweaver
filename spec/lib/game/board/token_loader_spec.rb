# frozen_string_literal: true

require 'rails_helper'
require 'securerandom'

RSpec.describe Game::Board::TokenLoader do
  it 'loads a token from flat data' do
    data = {
      id: SecureRandom.uuid,
      user_id: SecureRandom.uuid,
      token_id: SecureRandom.uuid,
      x: 1,
      y: 2,
      z: 3
    }

    loader = described_class.new(**data)

    expect(loader.token.id).to eq(data[:id])
    expect(loader.token).to be_valid
  end
end
