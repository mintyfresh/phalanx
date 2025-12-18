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
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
