# frozen_string_literal: true

module Network
  class ConnectionBlueprint < Blueprinter::Base
    identifier :id

    fields :status, :created_at, :updated_at

    association :users, blueprint: UserBlueprint
  end
end
