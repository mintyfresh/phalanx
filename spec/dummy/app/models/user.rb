# typed: strict
# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  email      :string           not null
#  first_name :string           not null
#  last_name  :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class User < ApplicationRecord
  has_many :role_assignments, as: :role_assignable, dependent: :destroy, inverse_of: :role_assignable
  has_many :roles, through: :role_assignments

  validates :email, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
end
