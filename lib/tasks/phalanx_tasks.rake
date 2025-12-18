# typed: false
# frozen_string_literal: true

namespace :phalanx do
  desc 'Generate the permission class'
  task generate: :environment do
    Phalanx.generate_permission_class
  end

  desc 'Check if the permission class is stale'
  task stale: :environment do
    if Phalanx.permission_class_stale?
      puts 'Permission class is stale'
      exit 1
    else
      exit 0
    end
  end
end
