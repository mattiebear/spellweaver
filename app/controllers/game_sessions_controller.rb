# frozen_string_literal: true

class GameSessionsController < ApplicationController
  def create
    authorize :game_session

    service = GameSessions::CreateService.new(
      user: current_user,
      name: params[:name],
      user_ids: params[:user_ids]
    ).run!

    render json: GameSessionBlueprint.render(service.result)
  end
end
