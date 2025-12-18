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

      sig { returns(T::Hash[String, T::Array[T.attached_class]]) }
      def permissions_by_group_name
        @permissions_by_group_name ||= T.let(
          T.unsafe(self).values.group_by(&:group_name).freeze,
          T.nilable(T::Hash[String, T::Array[T.attached_class]])
        )
      end

      sig { returns(T::Hash[String, T.attached_class]) }
      def permissions_index
        @permissions_index ||= T.let(
          T.unsafe(self).values.index_by(&:id).freeze,
          T.nilable(T::Hash[String, T.attached_class])
        )
      end

      sig { params(id: String).returns(T.attached_class) }
      def find(id)
        permissions_index[id] or
          Kernel.raise ArgumentError, "Permission with id #{id.inspect} not found"
      end

      sig { params(id: String).returns(T.nilable(T.attached_class)) }
      def [](id) # rubocop:disable Rails/Delegate
        permissions_index[id]
      end
    end

    mixes_in_class_methods ClassMethods

    sig { returns(String) }
    def id
      serialize[:id]
    end

    sig { returns(String) }
    def group_name
      serialize[:group_name]
    end

    sig { returns(String) }
    def name
      serialize[:name]
    end

    sig { returns(T.nilable(String)) }
    def description
      serialize[:description]
    end

    sig { returns(T.nilable(String)) }
    def depends_on_id
      serialize[:depends_on]
    end

    sig { returns(T.nilable(T.self_type)) }
    def depends_on
      (value = depends_on_id) && T.cast(self.class, ClassMethods[Permission]).find(value)
    end

    sig { returns(T::Array[Phalanx::Permission]) }
    def with_dependent_permissions
      [self, *depends_on&.with_dependent_permissions]
    end
  end
end
