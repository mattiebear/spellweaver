# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game::Board::Token do
  subject(:token) { described_class.new }

  it 'is invalid' do
    expect(token).not_to be_valid
  end

  it 'is valid with all attributes' do
    token.id = SecureRandom.uuid
    token.pos = build(:position)
    token.token_id = SecureRandom.uuid
    token.user_id = SecureRandom.uuid

    expect(token).to be_valid
  end
end
