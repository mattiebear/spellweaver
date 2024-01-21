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
FactoryBot.define do
  factory :map do
    atlas { { version: '1', data: {} } }

    sequence(:user_id) { |n| "user_#{n}" }
    sequence(:name) { |n| "Map #{n}" }
  end
end
