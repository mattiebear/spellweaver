# frozen_string_literal: true

module Game
  class GetMaps
    include Dry::Monads[:result]

    def execute(user:)
      fetch_maps(user)
    end

    private

    def fetch_maps(user)
      Success(Map.where(user_id: user.id))
    end
  end
end
