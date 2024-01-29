# frozen_string_literal: true

module Game
  class CreateMap
    include Dry::Monads[:result]

    def execute(user:, params:)
      build(params, user).bind do |map|
        save(map)
      end
    end

    private

    def build(params, user)
      map = Map.new(params).tap do |m|
        m.user_id = user.id
      end

      Success(map)
    end

    def save(map)
      if map.save
        Success(map)
      else
        Failure(CommandFailure.new(:unprocessable_entity))
      end
    end
  end
end
