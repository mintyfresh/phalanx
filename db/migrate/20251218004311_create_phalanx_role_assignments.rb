# typed: true
# frozen_string_literal: true

class CreatePhalanxRoleAssignments < ActiveRecord::Migration[8.1]
  extend T::Sig

  include Phalanx::MigrationExtensions

  sig { void }
  def change
    primary_key_type, foreign_key_type = primary_and_foreign_key_types

    create_table :phalanx_role_assignments, id: primary_key_type do |t|
      t.belongs_to :role, null: false, foreign_key: { to_table: :phalanx_roles }, type: foreign_key_type
      t.belongs_to :role_assignable, polymorphic: true, null: false, type: foreign_key_type
      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }

      t.index %i[role_id role_assignable_type role_assignable_id], unique: true
    end
  end
end
