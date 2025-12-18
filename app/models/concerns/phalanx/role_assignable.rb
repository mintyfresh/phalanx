# typed: strict
# frozen_string_literal: true

module Phalanx
  module RoleAssignable
    extend T::Sig
    extend T::Helpers
    extend ActiveSupport::Concern

    requires_ancestor { ActiveRecord::Base }

    included do
      T.bind(self, T.class_of(ActiveRecord::Base))

      has_many :role_assignments, as: :role_assignable, class_name: 'Phalanx::RoleAssignment',
                                  dependent: :destroy, inverse_of: :role_assignable
      has_many :roles, through: :role_assignments

      scope :with_assigned_permissions, -> { includes(roles: :role_permissions) }
    end

    sig { returns(T::Set[Phalanx::Permission]) }
    def permissions
      preload_roles_for_permissions_calculation! unless new_record? || T.unsafe(self).roles.loaded?

      T.unsafe(self).roles.flat_map(&:permissions).to_set
    end

  protected

    sig { void }
    def preload_roles_for_permissions_calculation!
      ActiveRecord::Associations::Preloader.new(
        records: [self],
        associations: { roles: :role_permissions }
      ).call
    end
  end
end
