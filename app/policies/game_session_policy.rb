# frozen_string_literal: true

class GameSessionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.with_user(user)
    end
  end

  def create?
    true
  end

  def show?
    record.includes_user?(user)
  end

  def update?
    record.owner?(user)
  end

  def destroy?
    record.owner?(user)
  end
end
