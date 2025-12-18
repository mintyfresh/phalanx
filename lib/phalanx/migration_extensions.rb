# typed: strict
# frozen_string_literal: true

module Phalanx
  module MigrationExtensions
    extend T::Sig

  private

    sig { returns([T.any(Symbol, String), T.any(Symbol, String)]) }
    def primary_and_foreign_key_types
      config = Rails.configuration.generators
      setting = config.options[config.orm][:primary_key_type]

      primary_key_type = setting || :primary_key
      foreign_key_type = setting || :bigint

      [primary_key_type, foreign_key_type]
    end
  end
end
