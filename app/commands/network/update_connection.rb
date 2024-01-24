# frozen_string_literal: true

module Network
  class UpdateConnection
    include Dry::Monads[:result]
    include Dry::Monads::Do.for(:execute)

    def initialize(by:, id:, params:)
      @user = by
      @id = id
      @params = params
    end

    def execute
      record = yield find_connection(id)
      yield ensure_user_is_part_of_connection(user, record)
      connection = yield update_connection(record, params)

      Success(connection)
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

    def update_connection(connection, params)
      if connection.update(params)
        Success(connection)
      else
        Failure(CommandFailure.new(:unprocessable_entity))
      end
    end
  end
end
