# typed: strict
# frozen_string_literal: true

module ParserHelpers
  extend T::Sig

  sig { params(subject: String, permissions: T::Array[Phalanx::Parser::Permission], scope: T.nilable(String)).returns(Phalanx::Parser::PermissionGroup) }
  def build_permission_group(subject:, permissions:, scope: nil)
    Phalanx::Parser::PermissionGroup.new(subject:, scope:, permissions:)
  end

  sig { params(id: String, name: String, scope: T.nilable(String), description: T.nilable(String), implies: T::Array[String]).returns(Phalanx::Parser::Permission) }
  def build_permission(id:, name: id, scope: nil, description: nil, implies: [])
    Phalanx::Parser::Permission.new(id:, name:, scope:, description:, implies:)
  end
end
