# typed: true
# frozen_string_literal: true

require 'rails'

module Phalanx
  class Engine < ::Rails::Engine
    isolate_namespace Phalanx

    config.generators.api_only = true

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
    end
  end
end
