# frozen_string_literal: true

module Connections
  class CreateService < Service
    def initialize(user:, username:)
      super

      self.user = user
      self.username = username
      self.user_client = Rogue::UserClient.new
    end

    def tasks
      validate_username
      find_recipient
      validate_existing_connection
      create_connection
    end

    private

    attr_accessor :connection, :existing, :recipient, :user, :username, :user_client

    def validate_username
      raise BadRequestError.new.add('username', ErrorCode::REQUIRED, 'Username is required') if username.blank?
    end

    def find_recipient
      self.recipient = user_client.search_one(username:)

      if recipient.blank?
        raise NotFoundError.new.add('username', ErrorCode::NOT_FOUND,
                                    'No user found with that name')
      end

      return unless recipient.id == user.id

      raise ConflictError.new.add('username', ErrorCode::INVALID,
                                  'Cannot send a request to yourself')
    end

    def validate_existing_connection
      connection = Network::Connection.between(user, recipient)

      return if connection.blank?

      raise ConflictError.new.add('connection', ErrorCode::ALREADY_EXISTS,
                                  'Connection already exists')
    end

    def create_connection
      Network::Connection.transaction do
        connection = Network::Connection.create(status: 'pending')

        connection.connection_users.create([
                                             { user_id: user.id, role: 'requester' },
                                             { user_id: recipient.id, role: 'recipient' }
                                           ])

        connection.connection_users.reload

        self.result = connection
      end
    end
  end
end
