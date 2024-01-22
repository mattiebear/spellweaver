# frozen_string_literal: true

module Network
  class UserBlueprint < Blueprinter::Base
    identifier :id

    fields :role, :user_id, :created_at, :updated_at

    association :user, blueprint: Access::UserBlueprint
  end
end
