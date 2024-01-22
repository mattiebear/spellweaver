# frozen_string_literal: true

module Game
  class SessionBlueprint < Blueprinter::Base
    identifier :id

    fields :name, :status

    association :players, blueprint: PlayerBlueprint
  end
end
