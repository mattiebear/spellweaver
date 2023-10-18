# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Story::Position do
  it 'parses data from a hash' do
    position = described_class.parse({ x: 3, y: 2, z: 6 })

    expect(position.to_h).to eq({ x: 3, y: 2, z: 6 })
  end

  it 'parses data from a hash with string keys' do
    position = described_class.parse({ 'x' => 3, 'y' => 2, 'z' => 6 })

    expect(position.to_h).to eq({ x: 3, y: 2, z: 6 })
  end

  it 'compares equal position' do
    position1 = described_class.new(1, 2, 3)
    position2 = described_class.new(1, 2, 3)

    expect(position1.equals?(position2)).to be(true)
  end

  it 'compares inequal position' do
    position1 = described_class.new(1, 2, 3)
    position2 = described_class.new(4, 2, 3)

    expect(position1.equals?(position2)).to be(false)
  end
end
