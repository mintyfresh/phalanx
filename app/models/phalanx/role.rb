# typed: strict
# frozen_string_literal: true

# == Schema Information
#
# Table name: phalanx_roles
#
#  id          :integer          not null, primary key
#  description :string
#  name        :string           not null
#  system      :boolean          default(FALSE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_phalanx_roles_on_name  (name) UNIQUE
#
module Phalanx
  class Role < ApplicationRecord
    extend T::Sig

    NAME_MAX_LENGTH = 50
    DESCRIPTION_MAX_LENGTH = 1000

    has_many :role_assignments, class_name: 'Phalanx::RoleAssignment',
                                dependent: :destroy, inverse_of: :role

    has_many :role_permissions, autosave: true, class_name: 'Phalanx::RolePermission',
                                dependent: :destroy, inverse_of: :role

    validates :name, presence: true, uniqueness: { if: :name_changed? }, length: { maximum: NAME_MAX_LENGTH }
    validates :description, length: { maximum: DESCRIPTION_MAX_LENGTH }
    validates :system, inclusion: { in: [true, false] }

    sig { returns(T::Boolean) }
    def user_defined?
      !system?
    end

    sig { returns(T::Array[Phalanx::Permission]) }
    def permissions
      role_permissions.reject(&:marked_for_destruction?).filter_map(&:permission)
    end

    sig { params(permissions: T::Enumerable[Phalanx::Permission]).void }
    def permissions=(permissions)
      permission_ids = permissions.flat_map(&:with_implied_permissions).to_set(&:id)

      role_permissions.each do |role_permission|
        next if role_permission.marked_for_destruction?

        if permission_ids.include?(role_permission.permission_id)
          permission_ids.delete(role_permission.permission_id)
        else
          role_permission.mark_for_destruction
        end
      end

      permission_ids.each do |permission_id|
        role_permissions.build(permission_id:)
      end
    end
  end
end
