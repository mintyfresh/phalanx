# == Schema Information
#
# Table name: role_assignments
#
#  id                   :integer          not null, primary key
#  role_assignable_type :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  role_assignable_id   :integer          not null
#  role_id              :integer          not null
#
# Indexes
#
#  idx_on_role_id_role_assignable_type_role_assignable_e2205e613b  (role_id,role_assignable_type,role_assignable_id) UNIQUE
#  index_role_assignments_on_role_assignable                       (role_assignable_type,role_assignable_id)
#  index_role_assignments_on_role_id                               (role_id)
#
# Foreign Keys
#
#  role_id  (role_id => roles.id)
#
require 'rails_helper'

RSpec.describe RoleAssignment, type: :model do
  subject(:role_assignment) { build(:role_assignment) }

  it { is_expected.to be_valid }
end
