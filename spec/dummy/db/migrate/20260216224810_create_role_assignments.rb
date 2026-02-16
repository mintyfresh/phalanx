# typed: true
# frozen_string_literal: true

class CreateRoleAssignments < ActiveRecord::Migration[8.1]
  def change
    create_table :role_assignments do |t|
      t.belongs_to :role, null: false, foreign_key: true
      t.belongs_to :role_assignable, polymorphic: true, null: false
      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }

      t.index %i[role_id role_assignable_type role_assignable_id], unique: true
    end
  end
end
