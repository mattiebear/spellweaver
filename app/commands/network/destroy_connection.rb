# frozen_string_literal: true

module Network
  class DestroyConnection
    include Dry::Monads[:result]
    include Dry::Monads::Do.for(:execute)

    def initialize(by:, id:)
      @user = by
      @id = id
    end

    def execute
      record = yield find_connection(id)
      yield ensure_user_is_part_of_connection(user, record)
      conneciton = yield destroy_connection(record)

      Success(conneciton)
    end

    private

    attr_reader :user, :id, :params

    def find_connection(id)
      connection = Connection.find_by(id:)

      if connection.present?
        Success(connection)
      else
        Failure(CommandFailure.new(:not_found))
      end
    end

    def ensure_user_is_part_of_connection(user, connection)
      if connection.includes_user?(user)
        Success(connection)
      else
        Failure(CommandFailure.new(:forbidden))
      end
    end

    def destroy_connection(connection)
      connection.destroy!

      Success(connection)
    end
  end
end
