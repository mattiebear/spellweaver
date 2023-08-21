# frozen_string_literal: true

class Player < ApplicationRecord
  include Ownable

  belongs_to :game_session

  enum role: {
    participant: 0,
    owner: 1
  }
end
