# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game::Messaging::MessageLoader do
  it 'loads a message' do
    message = described_class.new(event: 'test-event', data: { test: 'data' }).message

    expect(message).to be_success
    expect(message.value!).to be_a(Game::Messaging::Message)
    expect(message.value!.to_h).to eq(event: :test_event, data: { test: 'data' })
  end

  it 'converts the event name to snakecase' do
    message = described_class.new(event: 'test-event', data: { test: 'data' }).message

    expect(message.value!.event).to eq(:test_event)
  end

  it 'fails to load a message without an event' do
    message = described_class.new(event: nil, data: { test: 'data' }).message

    expect(message).to be_failure
    expect(message.failure).to eq(:no_event)
  end
end
