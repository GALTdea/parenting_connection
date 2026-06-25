# frozen_string_literal: true

class MemoryResponsePolicy < ApplicationPolicy
  def show?
    user.present? && record.child_profile.user_id == user.id
  end

  def new?
    create?
  end

  def create?
    show?
  end
end
