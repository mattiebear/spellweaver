# frozen_string_literal: true

class UserBlueprint < Blueprinter::Base
  identifier :id

  fields :image_url, :username
end
