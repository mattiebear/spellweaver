# frozen_string_literal: true

# == Schema Information
#
# Table name: connections
#
#  id         :uuid             not null, primary key
#  status     :integer          default("pending")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Connection < ApplicationRecord
  has_many :connection_users, dependent: :destroy

  enum status: {
    pending: 0,
    accepted: 1
  }

  scope :with_user, ->(user) { where(id: ConnectionUser.select(:connection_id).where(user_id: user.id)) }

  def includes_user?(user)
    connection_users.find_by(user_id: user.id).present?
  end

  def self.between(user, recipient)
    with_user(user).includes(:connection_users).find { |conn| conn.includes_user?(recipient) }
  end
end
