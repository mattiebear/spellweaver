# frozen_string_literal: true

# == Schema Information
#
# Table name: network_connections
#
#  id         :uuid             not null, primary key
#  status     :integer          default("pending")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module Network
  class Connection < ApplicationRecord
    has_many :users, class_name: 'Network::User', dependent: :destroy

    enum status: {
      pending: 0,
      accepted: 1
    }

    scope :with_user, ->(user) { where(id: User.select(:connection_id).where(user_id: user.id)) }

    def includes_user?(user)
      users.find_by(user_id: user.id).present?
    end

    def self.between(user, recipient)
      with_user(user).includes(:users).find { |conn| conn.includes_user?(recipient) }
    end
  end
end
