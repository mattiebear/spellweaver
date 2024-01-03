# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game::Actions::Director do
  it 'retrieves a registered action' do
    message = Game::Messaging::Message.new(event: :select_map, data: {})

    director = described_class.new(game_session_id: 'test', message:, user: {})

    expect(director.action.value!).to be_a(Game::Actions::SelectMap)
  end
end
