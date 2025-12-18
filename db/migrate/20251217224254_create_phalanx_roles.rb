# typed: true
# frozen_string_literal: true

class CreatePhalanxRoles < ActiveRecord::Migration[8.1]
  extend T::Sig

  include Phalanx::MigrationExtensions

  sig { void }
  def change
    primary_key_type, = primary_and_foreign_key_types

    create_table :phalanx_roles, id: primary_key_type do |t|
      t.string  :name, null: false, index: { unique: true }
      t.string  :description
      t.boolean :system, null: false, default: false
      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
