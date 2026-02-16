# == Schema Information
#
# Table name: phalanx_permission_assignments
#
#  id              :integer          not null, primary key
#  assignable_type :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  assignable_id   :bigint           not null
#  permission_id   :string           not null
#
# Indexes
#
#  idx_on_assignable_type_assignable_id_permission_id_db35db88c3  (assignable_type,assignable_id,permission_id) UNIQUE
#  index_phalanx_permission_assignments_on_assignable             (assignable_type,assignable_id)
#  index_phalanx_permission_assignments_on_permission_id          (permission_id)
#
require 'rails_helper'

module Phalanx
  RSpec.describe PermissionAssignment, type: :model do
    subject(:permission_assignment) { build(:permission_assignment) }

    it { is_expected.to be_valid }

    it { is_expected.to belong_to(:assignable) }

    it { is_expected.to validate_presence_of(:permission_id) }
  end
end
