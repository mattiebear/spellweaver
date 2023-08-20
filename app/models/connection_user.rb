# frozen_string_literal: true

class ConnectionUser < ApplicationRecord
  include Ownable

  belongs_to :connection

  enum role: {
    requester: 0,
    recipient: 1
  }
end
