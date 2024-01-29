# frozen_string_literal: true

module Game
  class GetMap
    include Dry::Monads[:result]

    def initialize(by:, id:)
      @id = id
      @user = by
    end

    def execute
      find_map(id, user)
    end

    private

    attr_reader :id, :user

    def find_map(id, user)
      map = Map.find_by(id:, user_id: user.id)

      if map
        Success(map)
      else
        Failure(CommandFailure.new(:not_found))
      end
    end
  end
end
