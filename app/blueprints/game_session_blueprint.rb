# frozen_string_literal: true

class GameSessionBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :status

  association :players, blueprint: PlayerBlueprint
end
