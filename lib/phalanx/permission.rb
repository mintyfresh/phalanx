# typed: strict
# frozen_string_literal: true

module Phalanx
  module Permission
    extend T::Sig
    extend T::Helpers

    requires_ancestor { T::Enum }

    module ClassMethods
      extend T::Sig
      extend T::Helpers
      extend T::Generic

      has_attached_class!(:out) { { upper: Phalanx::Permission } }

      # An index of all permissions mapped by their ID.
      sig { returns(T::Hash[String, T.attached_class]) }
      def permissions_by_id
        @permissions_by_id ||= T.let(
          T.unsafe(self).values.index_by(&:id).freeze,
          T.nilable(T::Hash[String, T.attached_class])
        )
      end

      # An index of all permissions mapped by their subject.
      sig { returns(T::Hash[String, T::Array[T.attached_class]]) }
      def permissions_by_subject
        @permissions_by_subject ||= T.let(
          T.unsafe(self).values.group_by(&:subject).freeze,
          T.nilable(T::Hash[String, T::Array[T.attached_class]])
        )
      end

      # An index of all permissions mapped by the IDs of the permissions that imply them.
      # NOTE: This is the inverse of the `implies` property in the permissions configuration file.
      sig { returns(T::Hash[String, T::Array[T.attached_class]]) }
      def implying_permissions_by_id
        @implying_permissions_by_id ||= T.let(
          T.unsafe(self).values
            .flat_map { |permission| permission.implied_permission_ids.map { |id| [id, permission] } }
            .group_by { |id, _| id }
            .transform_values { |permissions| permissions.map(&:last) }
            .freeze,
          T.nilable(T::Hash[String, T::Array[T.attached_class]])
        )
      end

      # Finds a permission by its ID.
      # @raise [Phalanx::PermissionNotFound] if the permission is not found.
      sig { params(id: String).returns(T.attached_class) }
      def find(id)
        permissions_by_id[id] or Kernel.raise Phalanx::PermissionNotFound, id
      end

      # Finds a permission by its ID.
      # Returns `nil` if the permission is not found.
      sig { params(id: String).returns(T.nilable(T.attached_class)) }
      def [](id) # rubocop:disable Rails/Delegate
        permissions_by_id[id]
      end
    end

    mixes_in_class_methods ClassMethods

    # The unique identifier of the permission.
    sig { returns(String) }
    def id
      serialize[:id]
    end

    # The subject that the permission belongs to.
    # e.g. A model name ("User", "Post", "Comment") or a application area ("Dashboard", "Admin", "API")
    sig { returns(String) }
    def subject
      serialize[:subject]
    end

    # The scope that the permission is part of.
    # Useful when working with multiple distinct sets of permissions (e.g. Global vs. Subject-specific).
    sig { returns(T.nilable(String)) }
    def scope
      serialize[:scope]
    end

    # A human-readable name of the permission.
    sig { returns(String) }
    def name
      serialize[:name]
    end

    # A human-readable description of the permission.
    sig { returns(T.nilable(String)) }
    def description
      serialize[:description]
    end

    # The list of permission IDs that are implied by having this permission.
    sig { returns(T::Array[String]) }
    def implied_permission_ids
      serialize[:implies]
    end

    # The list of permissions that are implied by having this permission.
    sig { returns(T::Array[Phalanx::Permission]) }
    def implied_permissions
      implied_permission_ids.map { |id| T.cast(self.class, ClassMethods[Permission]).find(id) }
    end

    # The list of permission IDs that imply this permission.
    # This is the inverse of #implied_permission_ids.
    sig { returns(T::Array[String]) }
    def implying_permission_ids
      implying_permissions.map(&:id)
    end

    # The list of permissions that imply this permission.
    # This is the inverse of #implied_permissions.
    sig { returns(T::Array[Phalanx::Permission]) }
    def implying_permissions
      T.cast(self.class, ClassMethods[Permission]).implying_permissions_by_id.fetch(id) { [] }
    end

    # The recursive list of permissions that are implied by having this permission, including this permission.
    # If no permissions are implied by this permission, returns a list containing only itself.
    sig { returns(T::Array[Phalanx::Permission]) }
    def with_implied_permissions
      [self, *implied_permissions.flat_map(&:with_implied_permissions)].uniq
    end
  end
end
