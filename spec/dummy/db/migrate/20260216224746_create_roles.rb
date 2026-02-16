# typed: true
# frozen_string_literal: true

class CreateRoles < ActiveRecord::Migration[8.1]
  def change
    create_table :roles do |t|
      t.string  :name, null: false, index: { unique: true }
      t.string  :description
      t.boolean :system, null: false, default: false
      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
