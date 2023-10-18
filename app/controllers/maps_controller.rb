# frozen_string_literal: true

class MapsController < ApplicationController
  def index
    maps = policy_scope(Map)

    render json: MapBlueprint.render(maps)
  end

  def show
    # TODO: Update map policy scope
    map = Map.find(params[:id])

    authorize map

    render json: MapBlueprint.render(map, view: :detail)
  end

  def create
    authorize :map

    map = Map.new(map_params).tap do |record|
      record.user_id = current_user.id
    end

    map.save!

    render json: MapBlueprint.render(map, view: :detail), status: :created
  end

  def update
    map = policy_scope(Map).find(params[:id])

    authorize map

    map.update!(map_params)

    render json: MapBlueprint.render(map, view: :detail)
  end

  def destroy
    map = policy_scope(Map).find(params[:id])

    authorize map

    map.destroy!
  end

  private

  def map_params
    params.require(:map).permit(:name, atlas: {})
  end
end
