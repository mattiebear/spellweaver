# frozen_string_literal: true

class ConnectionUserBlueprint < Blueprinter::Base
  identifier :id

  fields :role, :user_id, :created_at, :updated_at

  association :user, blueprint: UserBlueprint
end
