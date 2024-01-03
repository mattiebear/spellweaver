# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game::Board::Map do
  subject(:map) { described_class.new }

  it 'initializes with no tokens' do
    expect(map.token_count).to eq(0)
  end

  describe '#add_token' do
    it 'adds a token' do
      token = build(:token)

      result = map.add_token(token)

      expect(result).to be_success
      expect(map.token_count).to eq(1)
    end

    it 'fails to add a token at an occupied position' do
      pos = build(:position)
      token = build(:token, pos:)
      map.add_token(token)

      result = map.add_token(build(:token, pos:))

      expect(result).to be_failure
      expect(map.token_count).to eq(1)
    end
  end

  describe '#move_token' do
    it 'moves a token' do
      token = build(:token)
      map.add_token(token)

      result = map.move_token(token.id, build(:position, x: 1))

      expect(result).to be_success
    end

    it 'fails to move a token to an occupied position' do
      token = build(:token)
      map.add_token(token)
      map.add_token(build(:token, pos: build(:position, x: 1)))

      result = map.move_token(token.id, build(:position, x: 1))

      expect(result).to be_failure
    end
  end

  describe '#remove_token' do
    it 'removes a token' do
      token = build(:token)
      map.add_token(token)

      result = map.remove_token(token.id)

      expect(result).to be_success
      expect(map.token_count).to eq(0)
    end

    it 'fails to remove a token that does not exist' do
      result = map.remove_token(SecureRandom.uuid)

      expect(result).to be_failure
    end
  end

  describe '#get_token' do
    it 'gets a token' do
      token = build(:token)
      map.add_token(token)

      result = map.get_token(token.id)

      expect(result).to be_success
    end

    it 'fails to get a token that does not exist' do
      result = map.get_token(SecureRandom.uuid)

      expect(result).to be_failure
    end
  end
end
