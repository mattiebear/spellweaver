# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Story::Token do
  it 'compares equal position' do
    token = described_class.new(x: 1, y: 2, z: 3)
    position = Story::Position.new(1, 2, 3)

    expect(token.at?(position)).to be(true)
  end

  it 'compares inequal position' do
    token = described_class.new(x: 1, y: 2, z: 3)
    position = Story::Position.new(3, 2, 1)

    expect(token.at?(position)).to be(false)
  end
end
