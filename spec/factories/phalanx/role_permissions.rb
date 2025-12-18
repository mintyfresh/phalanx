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
FactoryBot.define do
  factory :role_permission do
    role { nil }
    permission_id { 'MyString' }
  end
end
