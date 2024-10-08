# frozen_string_literal: true

module Game
  module Actions
    # Base class for all executable actions
    class Action
      include Dry::Monads[:result]

      def initialize(game_session_id:, user: nil, data: nil)
        self.data = data
        self.game_session_id = game_session_id
        self.user = user
      end

      def execute!
        raise NoMethodError, 'execute! must be implemented by subclasses'
      end

      private

      attr_accessor :data, :game_session_id, :user

      def load_state
        State::Loader.new(game_session_id).load!
      end

      def success(event, data = nil)
        Success(ActionResult.new(event:, data:))
      end

      def author
        @author ||= Sync::Author.new([:story, game_session_id])
      end
    end
  end
end
