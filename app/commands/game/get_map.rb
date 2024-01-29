# frozen_string_literal: true

module Game
  class GetMap
    include Dry::Monads[:result]

    def execute(id:, user:)
      find_map(id, user).bind { |map| authorize(map, user) }
    end

    private

    def find_map(id, user)
      map = Map.find_by(id:, user_id: user.id)

      if map
        Success(map)
      else
        Failure(CommandFailure.new(:not_found))
      end
    end

    def authorize(map, user)
      if map.user_id == user.id
        Success(map)
      else
        Failure(CommandFailure.new(:unauthorized))
      end
    end
  end
end
