# frozen_string_literal: true

class GameSession < ApplicationRecord
  has_many :players, dependent: :destroy

  enum status: {
    pending: 0,
    active: 1,
    complete: 2
  }

  validates :name, length: { maximum: 100 }

  scope :with_user, ->(user) { where(id: Player.select(:game_session_id).where(user_id: user.id)) }

  def includes_user?(user)
    players.find_by(user_id: user.id).present?
  end

  def owner
    players.find_by(role: 'owner')
  end

  def owner?(user)
    owner&.user_id == user.id
  end
end
