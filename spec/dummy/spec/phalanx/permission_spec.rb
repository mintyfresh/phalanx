# typed: false
# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Phalanx::Permission do
  subject(:permission) { Permission::USERS_SHOW_OWN }

  describe '#id' do
    subject(:id) { permission.id }

    it { is_expected.to eq('users.show.own') }
  end

  describe '#group_name' do
    subject(:group_name) { permission.group_name }

    it { is_expected.to eq('User') }
  end

  describe '#name' do
    subject(:name) { permission.name }

    it { is_expected.to eq('Show own user') }
  end

  describe '#description' do
    subject(:description) { permission.description }

    it { is_expected.to eq('Allows the authenticated user to see their own account') }
  end

  describe '#implied_permission_ids' do
    subject(:implied_permission_ids) { permission.implied_permission_ids }

    it { is_expected.to be_empty }

    context 'with implied permissions' do
      let(:permission) { Permission::USERS_UPDATE_OWN }

      it { is_expected.to contain_exactly('users.show.own') }
    end
  end

  describe '#implied_permissions' do
    subject(:implied_permissions) { permission.implied_permissions }

    it { is_expected.to be_empty }

    context 'with implied permissions' do
      let(:permission) { Permission::USERS_UPDATE_OWN }

      it { is_expected.to contain_exactly(Permission::USERS_SHOW_OWN) }
    end
  end

  describe '#implying_permission_ids' do
    subject(:implying_permission_ids) { permission.implying_permission_ids }

    it { is_expected.to contain_exactly('users.update.own', 'users.show.any') }

    context 'without implying permissions' do
      let(:permission) { Permission::USERS_DESTROY_ANY }

      it { is_expected.to be_empty }
    end
  end

  describe '#implying_permissions' do
    subject(:implying_permissions) { permission.implying_permissions }

    it { is_expected.to contain_exactly(Permission::USERS_UPDATE_OWN, Permission::USERS_SHOW_ANY) }

    context 'without implying permissions' do
      let(:permission) { Permission::USERS_DESTROY_ANY }

      it { is_expected.to be_empty }
    end
  end

  describe '#with_implied_permissions' do
    subject(:with_implied_permissions) { permission.with_implied_permissions }

    it { is_expected.to contain_exactly(Permission::USERS_SHOW_OWN) }

    context 'with implied permissions' do
      let(:permission) { Permission::USERS_UPDATE_ANY }

      it do
        expect(with_implied_permissions).to contain_exactly(
          Permission::USERS_UPDATE_ANY,
          Permission::USERS_SHOW_OWN,
          Permission::USERS_UPDATE_OWN,
          Permission::USERS_SHOW_ANY
        )
      end
    end
  end
end
