# frozen_string_literal: true

module Game
  class DestroySession
    include Dry::Monads[:result]

    def initialize(by:, id:)
      @id = id
      @user = by
    end

    def execute
      find_session(id).bind do |map|
        authorize(map, user).bind do
          destroy(map)
        end
      end
    end

    private

    attr_reader :atlas, :id, :name, :user

    def find_session(id)
      session = Session.find_by(id:)

      if session
        Success(session)
      else
        Failure(CommandFailure.new(:not_found))
      end
    end

    def authorize(session, user)
      if session.includes_user?(user)
        Success(session)
      else
        Failure(CommandFailure.new(:unauthorized))
      end
    end

    def destroy(map)
      Success(map.destroy)
    end
  end
end
