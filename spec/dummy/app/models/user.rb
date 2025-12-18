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
  include Phalanx::RoleAssignable

  has_assigned_roles

  validates :email, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
end
