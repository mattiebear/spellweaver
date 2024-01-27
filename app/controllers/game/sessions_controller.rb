# frozen_string_literal: true

module Game
  class SessionsController < ApplicationController
    def index
      sessions = Session.includes(:players).with_user(current_user)

      render json: SessionBlueprint.render(sessions)
    end

    def show
      session = Session.find(params[:id])

      render json: SessionBlueprint.render(session)
    end

    def create
      service = GameSessions::CreateService.new(
        user: current_user,
        name: params[:name],
        user_ids: params[:user_ids]
      ).run!

      render json: SessionBlueprint.render(service.result)
    end

    def update
      session = Session.find(params[:id])

      service = GameSessions::UpdateService.new(
        game_session: session,
        params: session_params
      ).run!

      render json: SessionBlueprint.render(service.result)
    end

    def destroy
      session = Session.find(params[:id])

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
