# frozen_string_literal: true

module Game
  class SessionsController < ApplicationController
    def index
      result = Game::GetSessions.new(for: current_user).execute

      transmit(result, with: SessionBlueprint)
    end

    def show
      result = Game::GetSession.new(by: current_user, id: params[:id]).execute

      transmit(result, with: SessionBlueprint)
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
      result = GameSessions::DestroyService.new(
        by: current_user,
        id: params[:id]
      ).run!

      transmit(result)
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
