# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    # TODO: Add error handling for unauthorized
    def find_verified_user
      Rogue::Lockpick.new(request.params['token']).user
    end
  end
end
