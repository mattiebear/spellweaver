# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Network::CreateConnection do
  let(:user) { build(:access_user) }
  let(:recipient) { build(:access_user) }

  before do
    allow(Access).to receive(:find_user_by_username).and_return(recipient)
  end

  it 'creates a connection between two users' do
    expect { described_class.new.execute(user:, to: recipient.username) }.to change(Network::Connection, :count).by(1)
  end

  it 'fails if the username is blank' do
    result = described_class.new.execute(user:, to: '')

    expect(result).to be_failure
    expect(result.failure.status).to eq(:bad_request)
  end

  it 'fails if the recipient does not exist' do
    allow(Access).to receive(:find_user_by_username).and_return(nil)

    result = described_class.new.execute(user:, to: 'nonexistent')

    expect(result).to be_failure
    expect(result.failure.status).to eq(:not_found)
  end

  it 'fails if the recipient is the same as the user' do
    allow(Access).to receive(:find_user_by_username).and_return(user)

    result = described_class.new.execute(user:, to: 'nonexistent')

    expect(result).to be_failure
    expect(result.failure.status).to eq(:conflict)
  end

  it 'fails if the connection already exists' do
    allow(Network::Connection).to receive(:between).and_return(build(:network_connection))

    result = described_class.new.execute(user:, to: user.username)

    expect(result).to be_failure
    expect(result.failure.status).to eq(:conflict)
  end
end
