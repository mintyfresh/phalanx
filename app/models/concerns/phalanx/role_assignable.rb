# typed: strict
# frozen_string_literal: true

module Phalanx
  module RoleAssignable
    extend T::Sig
    extend T::Helpers
    extend ActiveSupport::Concern

    requires_ancestor { ActiveRecord::Base }

    class_methods do
      extend T::Sig

      sig { returns(Symbol) }
      def role_association_name
        T.bind(self, T.class_of(ActiveRecord::Base))

        @role_association_name or
          raise NotImplementedError,
                "#{self} does not define a relation to roles; " \
                'use either `has_assigned_roles` or `acts_like_role_assignment` to define one.'
      end

      sig { params(association_name: Symbol, inverse_of: T.nilable(T.any(Symbol, FalseClass))).void }
      def acts_like_role_assignment(association_name = :role, inverse_of: false)
        define_role_association_name(association_name)

        T.bind(self, T.class_of(ActiveRecord::Base))

        belongs_to(association_name, class_name: 'Phalanx::Role', inverse_of:)
      end

      sig { params(association_name: Symbol, dependent: Symbol).void }
      def has_assigned_roles(association_name = :roles, dependent: :destroy)
        define_role_association_name(association_name)

        T.bind(self, T.class_of(ActiveRecord::Base))

        has_many :role_assignments, as: :role_assignable, class_name: 'Phalanx::RoleAssignment',
                                    dependent:, inverse_of: :role_assignable
        has_many association_name, through: :role_assignments
      end

    private

      sig { params(subclass: T.untyped).void }
      def inherited(subclass)
        super
        subclass.instance_variable_set(:@role_association_name, @role_association_name)
      end

      sig { params(association_name: Symbol).void }
      def define_role_association_name(association_name)
        T.bind(self, T.class_of(ActiveRecord::Base))

        if @role_association_name.present? && @role_association_name != association_name
          raise ArgumentError, "#{self} already defines a role association with #{@role_association_name}"
        end

        @role_association_name = T.let(association_name, T.nilable(Symbol))
      end
    end

    sig { returns(T::Set[Phalanx::Permission]) }
    def permissions
      preload_roles_for_permissions_calculation!

      roles = public_send(role_association_name)

      case roles
      when ActiveRecord::Relation
        roles.flat_map(&:permissions).to_set
      when Phalanx::Role
        roles.permissions.to_set
      when nil
        Set.new
      else
        raise TypeError, "expected #{role_association_name} to be an ActiveRecord::Relation, " \
                         "Phalanx::Role, or nil (got #{roles.inspect})"
      end
    end

  protected

    sig { returns(Symbol) }
    def role_association_name
      T.cast(self.class, ClassMethods).role_association_name
    end

    sig { void }
    def preload_roles_for_permissions_calculation!
      ActiveRecord::Associations::Preloader.new(
        records: [self],
        associations: { role_association_name => :role_permissions }
      ).call
    end
  end
end
