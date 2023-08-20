# frozen_string_literal: true

class ConnectionsController < ApplicationController
  def index
    connections = policy_scope(Connection).includes(:connection_users)

    render json: ConnectionBlueprint.render(connections)
  end

  def create
    authorize :connection

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
