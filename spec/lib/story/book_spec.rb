# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Story::Book do
  it 'initializes player data from a game session' do
    game_session = create(:game_session)

    player = create(:player, game_session:)

    book = described_class.from_session(game_session)

    expect(book.to_h).to eq({
                              map_id: nil,
                              state: [],
                              players: [
                                {
                                  image: nil,
                                  role: player.role,
                                  user_id: player.user_id
                                }
                              ]
                            })
  end
end
