# frozen_string_literal: true

module GameSessions
  class UpdateService < Service
    def initialize(game_session:, params:)
      super

      self.game_session = game_session
      self.params = params
    end

    def tasks
      validate_status
      initialize_live_session
      update_session_params
    end

    private

    attr_accessor :game_session, :params

    def validate_status
      raise ConflictError.new.add('status', ErrorCode::INVALID, 'Invalid status') if completed? || restricted?
    end

    def initialize_live_session
      return unless initialize?

      GameSessions::InitializeService.new(game_session:).run!
    end

    def update_session_params
      game_session.update!(params)

      self.result = game_session
    end

    def status
      @status = params[:status]
    end

    def completed?
      game_session.complete?
    end

    def restricted?
      game_session.active? && status != 'complete'
    end

    def initialize?
      status == 'active'
    end
  end
end
