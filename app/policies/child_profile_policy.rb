# frozen_string_literal: true

class ChildProfilePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end

  def index?
    user.present?
  end

  def show?
    owns_record?
  end

  def create?
    user.present?
  end

  def update?
    owns_record?
  end

  def destroy?
    owns_record?
  end

  private

  def owns_record?
    record.user_id == user.id
  end
end
