# frozen_string_literal: true

module Network
  class ConnectionsController < ApplicationController
    def index
      result = Network::GetConnections.new(for: current_user).execute

      if result.success?
        render json: ConnectionBlueprint.render(result.value!)
      else
        render result.failure.to_response
      end
    end

    def create
      result = Network::CreateConnection.new(from: current_user, to: params[:username]).execute

      if result.success?
        render json: ConnectionBlueprint.render(result.value!)
      else
        render result.failure.to_response
      end
    end

    def update
      connection = Connection.find(params[:id])

      connection.update(connection_params)

      render json: ConnectionBlueprint.render(connection)
    end

    def destroy
      connection = Connection.find(params[:id])

      connection.destroy!
    end

    private

    def connection_params
      params.require(:connection).permit(:status)
    end
  end
end
