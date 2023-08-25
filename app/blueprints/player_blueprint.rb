# frozen_string_literal: true

class PlayerBlueprint < Blueprinter::Base
  identifier :id

  fields :role, :user_id

  association :user, blueprint: UserBlueprint
end
