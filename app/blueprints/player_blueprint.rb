# frozen_string_literal: true

class PlayerBlueprint < Blueprinter::Base
  identifier :id

  fields :role

  association :user, blueprint: UserBlueprint
end
