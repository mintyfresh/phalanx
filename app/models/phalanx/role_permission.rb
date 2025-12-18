# typed: strict
# frozen_string_literal: true

# == Schema Information
#
# Table name: phalanx_role_permissions
#
#  id            :integer          not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  permission_id :string           not null
#  role_id       :bigint           not null
#
# Indexes
#
#  index_phalanx_role_permissions_on_permission_id              (permission_id)
#  index_phalanx_role_permissions_on_role_id                    (role_id)
#  index_phalanx_role_permissions_on_role_id_and_permission_id  (role_id,permission_id) UNIQUE
#
# Foreign Keys
#
#  role_id  (role_id => phalanx_roles.id)
#
module Phalanx
  class RolePermission < ApplicationRecord
    extend T::Sig

    belongs_to :role, class_name: 'Phalanx::Role', inverse_of: :role_permissions

    validates :permission_id, presence: true

    sig { returns(T.nilable(Phalanx::Permission)) }
    def permission
      T.must(Phalanx.permission_class)[permission_id]
    end

    sig { params(permission: Phalanx::Permission).void }
    def permission=(permission)
      self.permission_id = permission.id
    end
  end
end
