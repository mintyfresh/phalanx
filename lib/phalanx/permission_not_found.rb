# typed: strict
# frozen_string_literal: true

module Phalanx
  class PermissionNotFound < Phalanx::Error
    extend T::Sig

    sig { returns(String) }
    attr_reader :id

    sig { params(id: String).void }
    def initialize(id)
      super("Permission with id #{id.inspect} not found")

      @id = id
    end
  end
end
