# frozen_string_literal: true

module Game
  class MapsController < ApplicationController
    def index
      maps = Map.where(user_id: current_user.id)

      render json: MapBlueprint.render(maps)
    end

    def show
      # TODO: Update map policy scope
      map = Map.find(params[:id])

      render json: MapBlueprint.render(map, view: :detail)
    end

    def create
      map = Map.new(map_params).tap do |record|
        record.user_id = current_user.id
      end

      map.save!

      render json: MapBlueprint.render(map, view: :detail), status: :created
    end

    def update
      map = Map.find(params[:id])

      map.update!(map_params)

      render json: MapBlueprint.render(map, view: :detail)
    end

    def destroy
      map = Map.find(params[:id])

      map.destroy!
    end

    private

    def map_params
      params.require(:map).permit(:name, atlas: {})
    end
  end
end
