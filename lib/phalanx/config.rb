# typed: strict
# frozen_string_literal: true

module Phalanx
  class Config
    extend T::Sig

    sig { returns(Pathname) }
    attr_accessor :schema_file_path

    sig { returns(T::Array[Pathname]) }
    attr_accessor :permission_file_paths

    sig { returns(Pathname) }
    attr_accessor :permission_file_path

    sig { returns(String) }
    attr_accessor :permission_class_name

    sig { void }
    def initialize
      @schema_file_path = T.let(T.unsafe(Phalanx::Engine).root.join('schema.json'), Pathname)
      @permission_file_paths = T.let([Rails.root.join('config/permissions/**/*.{yml,yaml}')], T::Array[Pathname])
      @permission_file_path = T.let(Rails.root.join('lib/permission.rb'), Pathname)
      @permission_class_name = T.let('Permission', String)
    end
  end
end
