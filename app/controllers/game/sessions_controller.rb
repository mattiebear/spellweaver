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
      result = Game::CreateSession.new(
        by: current_user,
        name: params[:name],
        participants: params[:user_ids],
        user_client: Rogue::UserClient.new
      ).execute

      transmit(result, with: SessionBlueprint)
    end

    def update
      result = Game::UpdateSession.new(
        by: current_user,
        id: params[:id],
        status: params[:status]
      ).execute

      transmit(result, with: SessionBlueprint)
    end

    def destroy
      result = Game::DestroySession.new(
        by: current_user,
        id: params[:id]
      ).execute

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
