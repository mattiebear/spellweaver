# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game::SessionPolicy, type: :policy do
  let(:user) { build(:access_user) }

  permissions '.scope' do
    it 'scopes to records on which the user is a participant' do
      owner = create(:game_session, players: create_list(:game_player, 1, role: 'owner', user_id: user.id))

      participant = create(:game_session, players: create_list(:game_player, 1, role: 'participant', user_id: user.id))

      create(:game_session, players: create_list(:game_player, 1))

      records = described_class::Scope.new(user, GameSession).resolve

      expect(records.pluck(:id)).to contain_exactly(owner.id, participant.id)
    end
  end

  permissions :create? do
    it 'permits' do
      expect(described_class).to permit(user, :create)
    end
  end

  permissions :show? do
    it 'permits if the user is a player' do
      game_session = create(:game_session,
                            players: create_list(:game_player, 1, role: 'participant', user_id: user.id))

      expect(described_class).to permit(user, game_session)
    end
  end

  permissions :update?, :destroy? do
    it 'permits if the user is an owner' do
      game_session = create(:game_session,
                            players: create_list(:game_player, 1, role: 'owner', user_id: user.id))

      expect(described_class).to permit(user, game_session)
    end

    it 'denies if the user is a participant player' do
      game_session = create(:game_session,
                            players: create_list(:game_player, 1, role: 'participant', user_id: user.id))

      expect(described_class).not_to permit(user, game_session)
    end
  end
end
