# frozen_string_literal: true

module Game
  class MapsController < ApplicationController
    def index
      result = Game::GetMaps.new(for: current_user).execute

      transmit(result, with: MapBlueprint)
    end

    def show
      result = Game::GetMap.new(by: current_user, id: params[:id]).execute

      transmit(result, with: MapBlueprint, view: :detail)
    end

    def create
      result = Game::CreateMap.new(
        by: current_user,
        params: map_params
      ).execute

      transmit(result, with: MapBlueprint, status: :created)
    end

    def update
      result = Game::UpdateMap.new(
        by: current_user,
        id: params[:id],
        params: map_params
      ).execute

      transmit(result, with: MapBlueprint, view: :detail)
    end

    def destroy
      result = Game::DestroyMap.new(by: current_user, id: params[:id]).execute

      transmit(result)
    end

    private

    def map_params
      params.require(:map).permit(:name, atlas: {})
    end
  end
end
