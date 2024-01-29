# frozen_string_literal: true

module Game
  class MapsController < ApplicationController
    def index
      result = Game::GetMaps.new.execute(user: current_user)

      transmit(result, with: MapBlueprint)
    end

    def show
      result = Game::GetMap.new.execute(user: current_user, id: params[:id])

      transmit(result, with: MapBlueprint, view: :detail)
    end

    def create
      result = Game::CreateMap.new.execute(
        user: current_user,
        params: map_params
      )

      transmit(result, with: MapBlueprint, status: :created)
    end

    def update
      result = Game::UpdateMap.new.execute(
        user: current_user,
        id: params[:id],
        params: map_params
      )

      transmit(result, with: MapBlueprint, view: :detail)
    end

    def destroy
      result = Game::DestroyMap.new.execute(user: current_user, id: params[:id])

      transmit(result)
    end

    private

    def map_params
      params.require(:map).permit(:name, atlas: {})
    end
  end
end
