# typed: false
# frozen_string_literal: true

# == Schema Information
#
# Table name: phalanx_roles
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
#  index_phalanx_roles_on_name  (name) UNIQUE
#
require 'rails_helper'

module Phalanx
  RSpec.describe Role, type: :model do
    subject(:role) { build(:role) }

    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(Role::NAME_MAX_LENGTH) }
    it { is_expected.to validate_length_of(:description).is_at_most(Role::DESCRIPTION_MAX_LENGTH) }

    describe '#permissions' do
      subject(:permissions) { role.permissions }

      let(:role) { build(:role, permissions: permissions_list) }
      let(:permissions_list) { Phalanx.permission_class.values.sample(3).flat_map(&:with_implied_permissions).uniq }

      it { is_expected.to match_array(permissions_list) }

      it 'excludes entries marked for destruction' do
        role_permission = role.role_permissions.sample
        role_permission.mark_for_destruction
        expect(permissions).to exclude(role_permission.permission)
      end

      it 'excludes stale permissions' do
        stale_permission = build(:role_permission, :stale, role:)
        role.role_permissions << stale_permission
        expect(permissions.map(&:id)).to exclude(stale_permission.permission_id)
      end
    end
  end
end
