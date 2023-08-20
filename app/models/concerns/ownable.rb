# frozen_string_literal: true

module Ownable
  extend ActiveSupport::Concern

  included do
    validates :user_id, presence: true, user_id: true
  end

  def user
    @user ||= Rogue::User.new(id: user_id)
  end

  def load_user!
    user.load!
  end
end
