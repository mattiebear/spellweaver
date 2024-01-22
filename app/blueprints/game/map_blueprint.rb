# frozen_string_literal: true

module Game
  class MapBlueprint < Blueprinter::Base
    identifier :id

    fields :name, :user_id, :created_at, :updated_at

    view :detail do
      fields :atlas
    end
  end
end
