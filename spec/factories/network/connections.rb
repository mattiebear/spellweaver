# frozen_string_literal: true

# == Schema Information
#
# Table name: connections
#
#  id         :uuid             not null, primary key
#  status     :integer          default("pending")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :network_connection, class: 'Network::Connection' do
    status { 'accepted' }
  end
end
