# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConnectionPolicy, type: :policy do
  let(:user) { build(:user) }

  permissions '.scope' do
    it 'scopes to records on which the user is a participant' do
      recipient_connection = create(:connection,
                                    connection_users: create_list(:connection_user, 1, role: 'recipient',
                                                                                       user_id: user.id))

      requester_connection = create(:connection,
                                    connection_users: create_list(:connection_user, 1, role: 'requester',
                                                                                       user_id: user.id))

      create(:connection, connection_users: create_list(:connection_user, 1))

      records = described_class::Scope.new(user, Connection).resolve

      expect(records.pluck(:id)).to contain_exactly(recipient_connection.id, requester_connection.id)
    end
  end

  permissions :create? do
    it 'permits' do
      expect(described_class).to permit(user, :map)
    end
  end

  permissions :show?, :update?, :destroy? do
    it 'permits if the user is a participant' do
      connection = create(:connection,
                          connection_users: create_list(:connection_user, 1, role: 'recipient',
                                                                             user_id: user.id))

      expect(described_class).to permit(user, connection)
    end

    it 'denies if the user is not a participant' do
      connection = create(:connection, connection_users: create_list(:connection_user, 1))

      expect(described_class).not_to permit(user, connection)
    end
  end
end
