# frozen_string_literal: true

class GameSessionsController < ApplicationController
  def index
    game_sessions = policy_scope(GameSession).includes(:players).where(filters)

    render json: GameSessionBlueprint.render(game_sessions)
  end

  def show
    game_session = policy_scope(GameSession).find(params[:id])

    authorize game_session

    render json: GameSessionBlueprint.render(game_session)
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

  def update
    game_session = policy_scope(GameSession).find(params[:id])

    authorize game_session

    service = GameSessions::UpdateService.new(
      game_session:,
      params: game_session_params
    ).run!

    render json: GameSessionBlueprint.render(service.result)
  end

  def destroy
    game_session = policy_scope(GameSession).find(params[:id])

    authorize game_session

    game_session.destroy!
  end

  private

  def filters
    Rest::ListFilters.new(params, :status).filters
  end

  def game_session_params
    params.require(:game_session).permit(:status)
  end
end
