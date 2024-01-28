# frozen_string_literal: true

module Game
  class GetMaps
    include Dry::Monads[:result]

    def initialize(**args)
      @user = args[:for]
    end

    def execute
      fetch_maps(user)
    end

    private

    attr_reader :user

    def fetch_maps(user)
      Success(Map.where(user_id: user.id))
    end
  end
end
