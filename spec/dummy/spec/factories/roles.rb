# typed: false
# frozen_string_literal: true

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
FactoryBot.define do
  factory :role do
    sequence(:name) { |n| "#{Faker::Lorem.word }-#{n}" }
    description { Faker::Lorem.sentence }
    system { false }
  end
end
