# frozen_string_literal: true

# == Schema Information
#
# Table name: maps
#
#  id         :uuid             not null, primary key
#  atlas      :json             not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :string           not null
#
# Indexes
#
#  index_maps_on_user_id           (user_id)
#  index_maps_on_user_id_and_name  (user_id,name) UNIQUE
#
class Map < ApplicationRecord
  validates :name, presence: true, length: { in: 1..250 }, uniqueness: { scope: :user_id }
  validates :user_id, presence: true, user_id: true
  validates :atlas, presence: true, atlas: true
end
