# frozen_string_literal: true

class Map < ApplicationRecord
  validates :name, presence: true, length: { in: 1..250 }, uniqueness: { scope: :user_id }
  validates :user_id, presence: true, user_id: true
  validates :atlas, presence: true, atlas: true
end
