# frozen_string_literal: true

module Game
  class UpdateMap
    include Dry::Monads[:result]

    def initialize(by:, id:, params:)
      @id = id
      @params = params
      @user = by
    end

    def execute
      find_map(id).bind do |map|
        authorize(map, user).bind do
          update(map, params)
        end
      end
    end

    private

    attr_reader :id, :params, :user

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

    def update(map, params)
      if map.update(params)
        Success(map)
      else
        Failure(CommandFailure.new(:unprocessable_entity))
      end
    end
  end
end
