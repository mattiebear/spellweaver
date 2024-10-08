# frozen_string_literal: true

# == Schema Information
#
# Table name: game_sessions
#
#  id         :uuid             not null, primary key
#  name       :string
#  status     :integer          default("pending")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module Game
  class Session < ApplicationRecord
    has_many :players, class_name: 'Game::Player', dependent: :destroy

    enum status: {
      pending: 0,
      active: 1,
      complete: 2
    }

    validates :name, length: { maximum: 100 }

    scope :with_user, ->(user) { where(id: Player.select(:session_id).where(user_id: user.id)) }

    def includes_user?(user)
      players.find_by(user_id: user.id).present?
    end

    def owner
      players.find_by(role: 'owner')
    end

    def owner?(user)
      owner&.user_id == user.id
    end

    def player?(user)
      includes_user?(user) && !owner?(user)
    end

    def transition_to?(new_status)
      return false if complete?

      case status
      when 'pending'
        new_status == 'active'
      when 'active'
        new_status == 'complete'
      else
        false
      end
    end
  end
end
