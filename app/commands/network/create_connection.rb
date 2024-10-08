# frozen_string_literal: true

module Network
  class CreateConnection
    include Dry::Monads[:result]
    include Dry::Monads::Do.for(:execute)

    def execute(user:, to:)
      username = yield validate_username(to)
      recipient = yield find_recipient(username)
      yield ensure_not_self(user, recipient)
      yield ensure_no_existing_connection(user, recipient)
      connection = yield create_connection(user, recipient)

      Success(connection)
    end

    private

    def validate_username(username)
      if username.present?
        Success(username)
      else
        failure = CommandFailure.new(:bad_request).add('username', ErrorCode::REQUIRED, 'Username is required')

        Failure(failure)
      end
    end

    def find_recipient(username)
      recipient = Access.find_user_by_username(username)

      if recipient.blank?
        failure = CommandFailure.new(:not_found).add('username', ErrorCode::NOT_FOUND, 'No user found with that name')

        Failure(failure)
      else
        Success(recipient)
      end
    end

    def ensure_not_self(user, recipient)
      if recipient.id == user.id
        failure = CommandFailure.new(:conflict).add('username', ErrorCode::INVALID, 'Cannot send a request to yourself')

        Failure(failure)
      else
        Success(recipient)
      end
    end

    def ensure_no_existing_connection(user, recipient)
      connection = Connection.between(user, recipient)

      if connection.present?
        failure = CommandFailure.new(:conflict).add('connection', ErrorCode::ALREADY_EXISTS,
                                                    'Connection already exists')

        Failure(failure)
      else
        Success(connection)
      end
    end

    def create_connection(user, recipient)
      Connection.transaction do
        connection = Connection.create(status: 'pending')

        connection.users.create([
                                  { user_id: user.id, role: 'requester' },
                                  { user_id: recipient.id, role: 'recipient' }
                                ])

        connection.users.reload

        Success(connection)
      end
    end
  end
end
