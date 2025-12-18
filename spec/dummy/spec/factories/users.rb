# typed: false
# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'MyString' }
    first_name { 'MyString' }
    last_name { 'MyString' }
  end
end
