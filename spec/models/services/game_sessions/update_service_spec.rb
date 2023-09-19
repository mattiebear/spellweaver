# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GameSessions::UpdateService do
  it 'disallows updating completed game sessions' do
    game_session = build(:game_session, status: 'complete')
    params = { status: 'active' }

    service = described_class.new(game_session:, params:)

    expect { service.run! }.to raise_error(ConflictError)
  end

  it 'disallows updating active sessions to a state other than "complete"' do
    game_session = build(:game_session, status: 'active')
    params = { status: 'active' }

    service = described_class.new(game_session:, params:)

    expect { service.run! }.to raise_error(ConflictError)
  end
end
