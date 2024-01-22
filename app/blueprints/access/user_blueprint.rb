# frozen_string_literal: true

module Access
  class UserBlueprint < Blueprinter::Base
    identifier :id

    fields :image_url, :username
  end
end
