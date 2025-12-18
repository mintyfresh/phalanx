# typed: strict
# frozen_string_literal: true

require 'json-schema'

module Phalanx
  class Parser
    class SchemaValidator
      extend T::Sig

      sig { params(schema_file_path: T.any(String, Pathname)).void }
      def initialize(schema_file_path)
        @schema_file_path = schema_file_path
        @schema = T.let(JSON.load_file(schema_file_path), T.untyped)
      end

      sig { params(permissions_data: T.untyped).void }
      def validate(permissions_data)
        JSON::Validator.validate!(@schema, permissions_data)
      end
    end
  end
end
