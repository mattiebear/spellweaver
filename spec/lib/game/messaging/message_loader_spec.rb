# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game::Messaging::MessageLoader do
  it 'loads a message' do
    message = described_class.new(event: :test_event, data: { test: 'data' }).message

		expect(message).to be_a(Game::Messaging::Message)
    expect(message.to_h).to eq(event: :test_event, data: { test: 'data' })
  end
end
