# typed: strict
# frozen_string_literal: true

require 'phalanx/version'
require 'phalanx/engine'

require 'phalanx/config'
require 'phalanx/generator'
require 'phalanx/parser'
require 'phalanx/permission'

module Phalanx
  extend T::Sig

  autoload :MigrationExtensions, 'phalanx/migration_extensions'

  PermissionClass = T.type_alias do
    T.all(
      T.class_of(T::Enum),
      T::Class[Phalanx::Permission],
      Phalanx::Permission::ClassMethods[Phalanx::Permission]
    )
  end

  sig { returns(Phalanx::Config) }
  def self.config
    @config ||= T.let(Phalanx::Config.new.freeze, T.nilable(Phalanx::Config))
  end

  sig { params(block: T.proc.params(config: Phalanx::Config).void).void }
  def self.configure(&block)
    config = self.config.dup
    block.call(config) # rubocop:disable Performance/RedundantBlockCall
    @config = config.freeze
  end

  sig { returns(T::Array[Pathname]) }
  def self.permission_file_paths
    config.permission_file_paths.flat_map { |path| Pathname.glob(path) }
  end

  sig { returns(PermissionClass) }
  def self.permission_class
    config.permission_class_name.safe_constantize or
      raise NotImplementedError, "Permission class #{config.permission_class_name.inspect} not found; " \
                                 'have you run `rails phalanx:generate`?'
  end

  sig { void }
  def self.generate_permission_class
    output_class_name = config.permission_class_name
    output_path = config.permission_file_path

    permission_groups = Parser.new(schema_file_path: config.schema_file_path).parse(permission_file_paths)
    Generator.new(permission_groups, output_class_name:, output_path:).generate
  end

  sig { returns(T::Boolean) }
  def self.permission_class_stale?
    output_class_name = config.permission_class_name
    output_path = config.permission_file_path

    permission_groups = Parser.new(schema_file_path: config.schema_file_path).parse(permission_file_paths)
    Generator.new(permission_groups, output_class_name:, output_path:).stale?
  end
end
