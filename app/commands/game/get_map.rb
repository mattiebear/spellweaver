# frozen_string_literal: true

module Game
  class GetMap
    include Dry::Monads[:result]

    def initialize(by:, id:)
      @id = id
      @user = by
    end

    def execute
      fetch_map(id, user)
    end

    private

    attr_reader :id, :user

    def fetch_map(id, user)
      map = Map.find_by(id:, user_id: user.id)

      if map
        Success(map)
      else
        Failure(CommandFailure.new(:unprocessable_entity))
      end
    end
  end
end
