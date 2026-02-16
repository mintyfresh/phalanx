# typed: true
# frozen_string_literal: true

class CreatePhalanxPermissionAssignments < ActiveRecord::Migration[8.1]
  extend T::Sig

  include Phalanx::MigrationExtensions

  sig { void }
  def change
    primary_key_type, foreign_key_type = primary_and_foreign_key_types

    create_table :phalanx_permission_assignments, id: primary_key_type do |t|
      t.belongs_to :assignable, polymorphic: true, null: false, type: foreign_key_type
      t.string     :permission_id, null: false, index: true
      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }

      t.index %i[assignable_type assignable_id permission_id], unique: true
    end
  end
end
