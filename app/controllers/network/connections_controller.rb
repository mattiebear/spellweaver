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
      authorize :connection, policy_class: Connection.policy_class

      service = Connections::CreateService.new(user: current_user, username: params[:username]).run!

      render json: ConnectionBlueprint.render(service.result)
    end

    def update
      connection = Connection.find(params[:id])

      authorize connection

      connection.update(connection_params)

      render json: ConnectionBlueprint.render(connection)
    end

    def destroy
      connection = Connection.find(params[:id])

      authorize connection

      connection.destroy!
    end

    private

    def connection_params
      params.require(:connection).permit(:status)
    end
  end
end
