# typed: strict
# frozen_string_literal: true

module Phalanx
  class Parser
    class Permission < T::Struct
      extend T::Sig

      const :id, String
      const :name, String
      const :scope, T.nilable(String)
      const :description, T.nilable(String)
      const :implies, T::Array[String]

      sig { returns(String) }
      def constant_name
        id.tr('.', '_').upcase
      end
    end
  end
end
