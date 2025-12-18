# typed: strict
# frozen_string_literal: true

require 'phalanx/parser/permission'
require 'phalanx/parser/permission_group'
require 'phalanx/parser/schema_validator'

module Phalanx
  class Parser
    extend T::Sig

    sig { params(schema_file_path: T.any(String, Pathname)).void }
    def initialize(schema_file_path:)
      @schema_validator = T.let(SchemaValidator.new(schema_file_path), SchemaValidator)
    end

    sig { params(file_paths: T::Array[T.any(String, Pathname)]).returns(T::Array[PermissionGroup]) }
    def parse(file_paths)
      file_paths.map do |file_path|
        permission_data = YAML.load_file(file_path)
        @schema_validator.validate(permission_data)

        PermissionGroup.new(
          name: permission_data['name'],
          permissions: permission_data['permissions'].map do |permission_id, permission_data|
            Permission.new(
              id: permission_id,
              name: permission_data['name'],
              description: permission_data['description'],
              depends_on: permission_data['depends_on']
            )
          end
        )
      end
    end
  end
end
