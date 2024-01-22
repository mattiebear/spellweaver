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
FactoryBot.define do
  factory :game_session, class: 'Game::Session' do
    status { 'pending' }
    name { 'Game Session' }
  end
end
