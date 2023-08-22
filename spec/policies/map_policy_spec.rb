# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MapPolicy, type: :policy do
  let(:user) { build(:user) }

  permissions '.scope' do
    it 'scopes to records owned by the user' do
      maps = create_list(:map, 3, user_id: user.id)

      other_user = build(:user)
      create_list(:map, 3, user_id: other_user.id)

      records = described_class::Scope.new(user, Map).resolve

      expect(records.pluck(:id)).to match_array(maps.pluck(:id))
    end
  end

  permissions :show?, :create? do
    it 'permits' do
      expect(described_class).to permit(user, :map)
    end
  end

  permissions :update?, :destroy? do
    it 'permits if the user owns the record' do
      map = build(:map, user_id: user.id)

      expect(described_class).to permit(user, map)
    end

    it 'denies if the user does not own the record' do
      restricted_user = build(:user)

      map = build(:map, user_id: restricted_user.id)

      expect(described_class).not_to permit(user, map)
    end
  end
end
