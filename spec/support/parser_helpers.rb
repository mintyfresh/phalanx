# typed: strict
# frozen_string_literal: true

module ParserHelpers
  extend T::Sig

  sig { params(name: String, permissions: T::Array[Phalanx::Parser::Permission]).returns(Phalanx::Parser::PermissionGroup) }
  def build_permission_group(name:, permissions:)
    Phalanx::Parser::PermissionGroup.new(name:, permissions:)
  end

  sig { params(id: String, name: String, description: T.nilable(String), implies: T::Array[String]).returns(Phalanx::Parser::Permission) }
  def build_permission(id:, name: id, description: nil, implies: [])
    Phalanx::Parser::Permission.new(id:, name:, description:, implies:)
  end
end
