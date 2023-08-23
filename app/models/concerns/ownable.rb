# frozen_string_literal: true

module Ownable
  extend ActiveSupport::Concern

  included do
    validates :user_id, presence: true, user_id: true
  end

  def user
    @user ||= Rogue::UserClient.new.find(user_id)
  end

  def user=(user)
    @user = user
  end
end
