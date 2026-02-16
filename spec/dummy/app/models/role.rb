# typed: strict
# frozen_string_literal: true

# == Schema Information
#
# Table name: roles
#
#  id          :integer          not null, primary key
#  description :string
#  name        :string           not null
#  system      :boolean          default(FALSE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_roles_on_name  (name) UNIQUE
#
class Role < ApplicationRecord
  include Phalanx::PermissionAssignable

  has_many :role_assignments, dependent: :destroy, inverse_of: :role

  validates :name, presence: true, uniqueness: true
  validates :description, length: { maximum: 1000 }
  validates :system, inclusion: { in: [true, false] }
end
