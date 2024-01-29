# frozen_string_literal: true

module Network
  class ConnectionsController < ApplicationController
    def index
      result = Network::GetConnections.new.execute(user: current_user)

      transmit(result, with: ConnectionBlueprint)
    end

    def create
      result = Network::CreateConnection.new.execute(user: current_user, to: params[:username])

      transmit(result, with: ConnectionBlueprint, status: :created)
    end

    def update
      result = Network::UpdateConnection.new.execute(id: params[:id], user: current_user, params: connection_params)

      transmit(result, with: ConnectionBlueprint)
    end

    def destroy
      Network::DestroyConnection.new.execute(id: params[:id], by: current_user)

      transmit(nil, status: :no_content)
    end

    private

    def connection_params
      params.require(:connection).permit(:status)
    end
  end
end
