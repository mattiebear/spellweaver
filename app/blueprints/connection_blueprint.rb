# frozen_string_literal: true

class ConnectionBlueprint < Blueprinter::Base
  identifier :id

  fields :status, :created_at, :updated_at

  association :connection_users, blueprint: ConnectionUserBlueprint
end
