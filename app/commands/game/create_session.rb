# frozen_string_literal: true

module Game
  class CreateMap
    include Dry::Monads[:result]

    def initialize(by:, params:)
      @params = params
      @user = by
    end

    def execute
      build(params, user:).bind do |map|
        save(map)
      end
    end

    private

    attr_reader :params, :user

    def build(params, user:)
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
