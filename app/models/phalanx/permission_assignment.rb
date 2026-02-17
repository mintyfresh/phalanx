# typed: strict
# frozen_string_literal: true

# == Schema Information
#
# Table name: phalanx_permission_assignments
#
#  id              :integer          not null, primary key
#  assignable_type :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  assignable_id   :bigint           not null
#  permission_id   :string           not null
#
# Indexes
#
#  idx_on_assignable_type_assignable_id_permission_id_db35db88c3  (assignable_type,assignable_id,permission_id) UNIQUE
#  index_phalanx_permission_assignments_on_assignable             (assignable_type,assignable_id)
#  index_phalanx_permission_assignments_on_permission_id          (permission_id)
#
module Phalanx
  class PermissionAssignment < ApplicationRecord
    extend T::Sig

    belongs_to :assignable, polymorphic: true

    validates :permission_id, presence: true

    validate :permission_must_have_supported_permission_scope

    scope :stale, -> { where.not(permission_id: Phalanx.permission_class.values.map(&:id)) }

    sig { returns(T::Boolean) }
    def stale?
      permission_id.present? && permission.nil?
    end

    sig { returns(T.nilable(Phalanx::Permission)) }
    def permission
      permission_id.present? ? Phalanx.permission_class[permission_id] : nil
    end

    sig { params(permission: Phalanx::Permission).void }
    def permission=(permission)
      self.permission_id = permission.id
    end

    sig { returns(T::Boolean) }
    def permission_scope_supported?
      return false if (assignable = self.assignable).nil? || (permission = self.permission).nil?

      assignable.permission_scope_supported?(permission.scope)
    end

  private

    sig { void }
    def permission_must_have_supported_permission_scope
      return if (assignable = self.assignable).nil? || (permission = self.permission).nil?
      return if permission_scope_supported?

      errors.add(:permission, :unsupported_permission_scope, scope: permission.scope)
    end
  end
end
