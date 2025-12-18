# typed: false
# frozen_string_literal: true

# == Schema Information
#
# Table name: phalanx_role_permissions
#
#  id            :integer          not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  permission_id :string           not null
#  role_id       :bigint           not null
#
# Indexes
#
#  index_phalanx_role_permissions_on_permission_id              (permission_id)
#  index_phalanx_role_permissions_on_role_id                    (role_id)
#  index_phalanx_role_permissions_on_role_id_and_permission_id  (role_id,permission_id) UNIQUE
#
# Foreign Keys
#
#  role_id  (role_id => phalanx_roles.id)
#
require 'rails_helper'

module Phalanx
  RSpec.describe RolePermission, type: :model do
    subject(:role_permission) { build(:role_permission) }

    it { is_expected.to be_valid }

    it { is_expected.to belong_to(:role) }
    it { is_expected.to validate_presence_of(:permission_id) }

    it { is_expected.not_to be_stale }

    context 'when the permission ID does not exist' do
      subject(:role_permission) { build(:role_permission, permission_id: 'non-existent-permission-id') }

      it { is_expected.to be_valid }
      it { is_expected.to be_stale }
    end
  end
end
