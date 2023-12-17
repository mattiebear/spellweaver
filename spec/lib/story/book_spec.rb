# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Story::Book do
  it 'initializes player data from a game session' do
    game_session = create(:game_session)

    book = described_class.new(game_session, build(:user))

    expect(book.to_h).to eq({
                              map_id: nil,
                              tokens: []
                            })
  end
end
