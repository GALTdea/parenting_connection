# frozen_string_literal: true

class MemoryResponsePolicy < ApplicationPolicy
  def new?
    create?
  end

  def create?
    user.present? && record.child_profile.user_id == user.id
  end
end
