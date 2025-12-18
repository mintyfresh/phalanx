# typed: strict
# frozen_string_literal: true

module Phalanx
  class Parser
    class PermissionGroup < T::Struct
      const :name, String
      const :permissions, T::Array[Parser::Permission]
    end
  end
end
