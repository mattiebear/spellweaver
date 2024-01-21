# frozen_string_literal: true

module Game
  class MapPolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        scope.where(user_id: user.id)
      end
    end

    def create?
      true
    end

    def show?
      true
    end

    def update?
      record.user_id == user.id
    end

    def destroy?
      record.user_id == user.id
    end
  end
end
