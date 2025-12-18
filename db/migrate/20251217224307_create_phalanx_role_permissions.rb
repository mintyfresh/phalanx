# typed: true
# frozen_string_literal: true

class CreatePhalanxRolePermissions < ActiveRecord::Migration[8.1]
  extend T::Sig

  include Phalanx::MigrationExtensions

  sig { void }
  def change
    primary_key_type, foreign_key_type = primary_and_foreign_key_types

    create_table :phalanx_role_permissions, id: primary_key_type do |t|
      t.belongs_to :role, null: false, foreign_key: { to_table: :phalanx_roles }, type: foreign_key_type
      t.string     :permission_id, null: false, index: true
      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }

      t.index %i[role_id permission_id], unique: true
    end
  end
end
