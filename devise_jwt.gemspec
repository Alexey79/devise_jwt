# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'devise_jwt/version'

Gem::Specification.new do |spec|
  spec.name          = 'devise_jwt'
  spec.version       = DeviseJwt::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ['Alexey Kirichenko']
  spec.email         = ['Alexey.Kirichenko@gmail.com']

  spec.summary       = 'Json Web Token authentication solution for Rails'
  spec.description   = 'Json Web Token authentication solution for Rails'
  spec.homepage      = 'https://github.com/Alexey79/devise_jwt'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|features)/}) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.1.0'

  spec.add_dependency('railties', '>= 4.1.0', '< 5.1')
  spec.add_dependency 'devise', '> 3.5.2', '< 4.1'
  spec.add_dependency 'jwt', '~> 1.5.3', '< 2'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
end
