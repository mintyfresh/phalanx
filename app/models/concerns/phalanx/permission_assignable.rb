# typed: strict
# frozen_string_literal: true

module Phalanx
  module PermissionAssignable
    extend T::Sig
    extend T::Helpers
    extend ActiveSupport::Concern

    requires_ancestor { ActiveRecord::Base }

    included do
      T.bind(self, T.class_of(ActiveRecord::Base))

      has_many :permission_assignments, as: :assignable, autosave: true, class_name: 'Phalanx::PermissionAssignment',
                                        dependent: :destroy, inverse_of: :assignable
    end

    module ClassMethods
      extend T::Sig

      sig { params(scopes: String).void }
      def permitted_permission_scopes(*scopes)
        T.bind(self, T.class_of(ActiveRecord::Base))
        define_method(:permitted_permission_scopes) { scopes }
      end
    end

    mixes_in_class_methods ClassMethods

    sig { returns(T::Set[Phalanx::Permission]) }
    def permissions
      T.let(T.unsafe(self).permission_assignments, T::Enumerable[Phalanx::PermissionAssignment])
        .reject { |assignment| assignment.marked_for_destruction? || !assignment.permission_scope_supported? }
        .filter_map(&:permission)
        .flat_map(&:with_implied_permissions)
        .to_set
    end

    sig { params(permissions: T::Enumerable[Phalanx::Permission]).void }
    def permissions=(permissions)
      permission_ids = permissions.flat_map(&:with_implied_permissions).to_set(&:id)

      T.unsafe(self).permission_assignments.each do |permission_assignment|
        next if permission_assignment.marked_for_destruction?

        if permission_ids.include?(permission_assignment.permission_id)
          permission_ids.delete(permission_assignment.permission_id)
        else
          permission_assignment.mark_for_destruction
        end
      end

      permission_ids.each do |permission_id|
        T.unsafe(self).permission_assignments.build(permission_id:)
      end
    end

    sig { returns(T::Boolean) }
    def permission_assignments_changed?
      T.unsafe(self).permission_assignments.target.any?(&:changed_for_autosave?)
    end

    sig { overridable.returns(T.nilable(T.any(String, T::Enumerable[String]))) }
    def permitted_permission_scopes
      nil
    end

    sig { params(scope: String).returns(T::Boolean) }
    def permission_scope_supported?(scope)
      case (scopes = permitted_permission_scopes)
      when Enumerable then scopes.include?(scope)
      when String then scopes == scope
      when nil then true
      else T.absurd(scopes)
      end
    end
  end
end
