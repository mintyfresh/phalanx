# typed: false
# frozen_string_literal: true

# == Schema Information
#
# Table name: phalanx_role_assignments
#
#  id                   :integer          not null, primary key
#  role_assignable_type :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  role_assignable_id   :bigint           not null
#  role_id              :bigint           not null
#
# Indexes
#
#  idx_on_role_id_role_assignable_type_role_assignable_36ad7ae555  (role_id,role_assignable_type,role_assignable_id) UNIQUE
#  index_phalanx_role_assignments_on_role_assignable               (role_assignable_type,role_assignable_id)
#  index_phalanx_role_assignments_on_role_id                       (role_id)
#
# Foreign Keys
#
#  role_id  (role_id => phalanx_roles.id)
#
require 'rails_helper'

module Phalanx
  RSpec.describe RoleAssignment, type: :model do
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
