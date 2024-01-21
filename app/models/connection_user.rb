# frozen_string_literal: true

# == Schema Information
#
# Table name: connection_users
#
#  id            :uuid             not null, primary key
#  role          :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  connection_id :uuid             not null
#  user_id       :string
#
# Indexes
#
#  index_connection_users_on_connection_id  (connection_id)
#  index_connection_users_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (connection_id => connections.id)
#
class ConnectionUser < ApplicationRecord
  include Ownable

  belongs_to :connection

  enum role: {
    requester: 0,
    recipient: 1
  }
end
