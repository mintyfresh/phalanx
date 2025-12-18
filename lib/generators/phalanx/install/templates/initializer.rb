# typed: true
# frozen_string_literal: true

Phalanx.configure do |config|
  # To change the name of the permission class, you can specify a custom class name.
  #
  # config.permission_class_name = 'Permission'

  # To change the location of the permission class file, you can specify a custom file path.
  # This should match the class name specified in `config.permission_class_name`
  # for the class loader to be able to find the class.
  #
  # config.permission_file_path = Rails.root.join('lib/permission.rb')

  # To change the location from which permission files are loaded, you can specify a custom glob pattern.
  # Multiple patterns can be specified if needed.
  #
  # config.permission_file_paths = [
  #   Rails.root.join('config/permissions/**/*.{yml,yaml}'),
  # ]

  # If extending the permissions DSL, you can specify your own custom JSON schema file.
  #
  # config.schema_file_path = Rails.root.join('config/permissions-schema.json')
end
