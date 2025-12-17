# typed: strict
# frozen_string_literal: true

module Phalanx
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
