# frozen_string_literal: true

module Access
  def self.table_name_prefix
    'access_'
  end

  def self.find_user_by_username(username)
    Rogue::UserClient.new.search_one(username:)
  end
end
