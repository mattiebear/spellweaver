# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game::Messaging::DataTransformer do
  it 'transforms an outbound data parcel' do
    data = { test_value: 'data' }

		transformer = described_class.new(data)

		expect(transformer.outbound).to eq('testValue' => 'data')
  end

	it 'transforms an inbound data parcel' do
		data = { 'testValue' => 'data' }

		transformer = described_class.new(data)

		expect(transformer.inbound).to eq(test_value: 'data')
	end
end
