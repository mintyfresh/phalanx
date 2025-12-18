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
FactoryBot.define do
  factory :role, class: 'Phalanx::Role' do
    sequence(:name) { |i| "role_#{i}" }
    description { Faker::Hipster.sentence }

    trait :system do
      system { true }
    end

    trait :user_defined do
      system { false }
    end
  end
end
