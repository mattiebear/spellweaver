# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game::Messaging::Message do
  it 'serializes to a data object' do
    message = described_class.new(event: :test_event, data: { test: 'data' })

    expect(message.to_h).to eq(event: :test_event, data: { test: 'data' })
  end
end
