# frozen_string_literal: true

module Game
  class SessionsController < ApplicationController
    def index
      sessions = policy_scope(Session).includes(:players).where(filters)

      render json: SessionBlueprint.render(sessions)
    end

    def show
      session = policy_scope(Session).find(params[:id])

      authorize session

      render json: SessionBlueprint.render(session)
    end

    def create
      authorize :session, policy_class: Session.policy_class

      service = GameSessions::CreateService.new(
        user: current_user,
        name: params[:name],
        user_ids: params[:user_ids]
      ).run!

      render json: SessionBlueprint.render(service.result)
    end

    def update
      session = policy_scope(Session).find(params[:id])

      authorize session

      service = GameSessions::UpdateService.new(
        game_session: session,
        params: session_params
      ).run!

      render json: SessionBlueprint.render(service.result)
    end

    def destroy
      session = policy_scope(Session).find(params[:id])

      authorize session

      session.destroy!
    end

    private

    def filters
      Rest::ListFilters.new(params, :status).filters
    end

    def session_params
      params.require(:session).permit(:status)
    end
  end
end
