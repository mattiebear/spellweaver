# frozen_string_literal: true

module Game
  class DestroyMap
    include Dry::Monads[:result]

    def execute(user:, id:)
      find_map(id).bind do |map|
        authorize(map, user).bind do
          destroy(map)
        end
      end
    end

    private

    def find_map(id)
      map = Map.find_by(id:)

      if map
        Success(map)
      else
        Failure(CommandFailure.new(:not_found))
      end
    end

    def authorize(map, user)
      # TODO: Use configurable policy class
      if map.user_id == user.id
        Success(map)
      else
        Failure(CommandFailure.new(:unauthorized))
      end
    end

    def destroy(map)
      Success(map.destroy)
    end
  end
end
