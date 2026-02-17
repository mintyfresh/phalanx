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
require 'rails_helper'

RSpec.describe Role, type: :model do
  subject(:role) { build(:role) }

  it { is_expected.to be_valid }

  describe '#permissions' do
    subject(:permissions) { role.permissions }

    let(:role) { build(:role, permissions: permissions_list) }
    let(:permissions_list) { permission_ids.map { |id| Phalanx.permission_class[id] } }
    let(:permission_ids) { %w[users.show.own users.update.own users.destroy.own] }

    it { is_expected.to match_array(permissions_list) }

    it 'excludes entries marked for destruction' do
      permission_assignment = role.permission_assignments.find do |assignment|
        assignment.permission_id == 'users.destroy.own'
      end
      permission_assignment.mark_for_destruction
      expect(permissions).to exclude(permission_assignment.permission)
    end

    it 'excludes stale permissions' do
      stale_permission = build(:permission_assignment, :stale, assignable: role)
      role.permission_assignments << stale_permission
      expect(permissions.map(&:id)).to exclude(stale_permission.permission_id)
    end
  end
end
