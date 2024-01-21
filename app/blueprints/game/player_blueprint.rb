# frozen_string_literal: true

module Game
  class PlayerBlueprint < Blueprinter::Base
    identifier :id

    fields :role, :user_id

    association :user, blueprint: Access::UserBlueprint
  end
end
