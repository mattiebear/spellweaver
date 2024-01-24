# frozen_string_literal: true

module Network
  class ConnectionsController < ApplicationController
    def index
      result = Network::GetConnections.new(for: current_user).execute

      transmit(result, with: ConnectionBlueprint)
    end

    def create
      result = Network::CreateConnection.new(from: current_user, to: params[:username]).execute

      transmit(result, with: ConnectionBlueprint, status: :created)
    end

    def update
      result = Network::UpdateConnection.new(id: params[:id], by: current_user, params: connection_params).execute

      transmit(result, with: ConnectionBlueprint)
    end

    def destroy
      Network::DestroyConnection.new(id: params[:id], by: current_user).execute

      transmit(nil, status: :no_content)
    end

    private

    def connection_params
      params.require(:connection).permit(:status)
    end
  end
end
