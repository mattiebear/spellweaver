# frozen_string_literal: true

class GameSessionsController < ApplicationController
  def index
    game_sessions = policy_scope(GameSession).where(filters)

    render json: GameSessionBlueprint.render(game_sessions)
  end

  def create
    authorize :game_session

    service = GameSessions::CreateService.new(
      user: current_user,
      name: params[:name],
      user_ids: params[:user_ids]
    ).run!

    render json: GameSessionBlueprint.render(service.result)
  end

  private

  def filters
    Rest::ListFilters.new(params, :status).filters
  end
end
