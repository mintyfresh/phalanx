# frozen_string_literal: true

require_relative 'lib/phalanx/version'

Gem::Specification.new do |spec|
  spec.name        = 'phalanx'
  spec.version     = Phalanx::VERSION
  spec.authors     = ['Minty Fresh']
  spec.email       = ['7896757+mintyfresh@users.noreply.github.com']
  spec.homepage    = 'https://github.com/mintyfresh/phalanx'
  spec.summary     = 'Fine-grained permissions for Rails + Sorbet.'
  spec.description = 'Fine-grained permissions for Rails + Sorbet.'
  spec.license     = 'MIT'

  spec.required_ruby_version = '>= 3.4'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/mintyfresh/phalanx'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md', 'schema.json']
  end

  spec.add_dependency 'json-schema'
  spec.add_dependency 'rails', '>= 8.1.1'
  spec.add_dependency 'sorbet'
end
