# typed: true
# frozen_string_literal: true

module Phalanx
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    def create_initializer
      template 'initializer.rb', 'config/initializers/phalanx.rb'
    end
  end
end
