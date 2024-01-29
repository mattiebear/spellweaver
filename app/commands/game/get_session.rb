# frozen_string_literal: true

module Game
  class GetSession
    include Dry::Monads[:result]

    def initialize(by:, id:)
      @id = id
      @user = by
    end

    def execute
      find_session { |session| authorize(session) }
    end

    private

    attr_reader :id, :user

    def find_session
      session = Session.find_by(id:)

      if session
        Success(session)
      else
        Failure(CommandFailure.new(:not_found))
      end
    end

    def authorize(session)
      if session.includes_user?(user)
        Success(session)
      else
        Failure(CommandFailure.new(:unauthorized))
      end
    end
  end
end
