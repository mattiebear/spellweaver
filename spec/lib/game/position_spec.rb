# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game::Position do
  it 'compares equal position' do
    pos1 = described_class.new(x: 1, y: 2, z: 3)
    pos2 = described_class.new(x: 1, y: 2, z: 3)

    expect(pos1.equals?(pos2)).to be(true)
  end

  it 'compares inequal position' do
    pos1 = described_class.new(x: 1, y: 2, z: 3)
    pos2 = described_class.new(x: 4, y: 2, z: 3)

    expect(pos1.equals?(pos2)).to be(false)
  end
end
