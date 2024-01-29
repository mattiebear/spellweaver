# frozen_string_literal: true

module Game
  class SessionsController < ApplicationController
    def index
      result = Game::GetSessions.new.execute(user: current_user)

      transmit(result, with: SessionBlueprint)
    end

    def show
      result = Game::GetSession.new.execute(by: current_user, id: params[:id])

      transmit(result, with: SessionBlueprint)
    end

    def create
      result = Game::CreateSession.new.execute(
        by: current_user,
        name: params[:name],
        participants: params[:user_ids],
        user_client: Rogue::UserClient.new
      )

      transmit(result, with: SessionBlueprint)
    end

    def update
      result = Game::UpdateSession.new.execute(
        by: current_user,
        id: params[:id],
        status: params[:status]
      )

      transmit(result, with: SessionBlueprint)
    end

    def destroy
      result = Game::DestroySession.new.execute(
        by: current_user,
        id: params[:id]
      )

      transmit(result)
    end

    private

    def session_params
      params.require(:session).permit(:status)
    end
  end
end
