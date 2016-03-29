# devise
require 'rails'
require 'devise'
require 'devise/models/jwt_authenticatable'
require 'devise/strategies/jwt_authenticatable'

# devise_jwt
require 'devise_jwt/engine'
require 'devise_jwt/version'

module DeviseJwt
  autoload :JwtFailureApp,                'devise_jwt/jwt_failure_app'

  def self.setup
    yield self
  end

  mattr_accessor :secret
  @@secret = nil

  mattr_accessor :expiration_time
  @@expiration_time = 0.hours
end

Devise.add_module(:jwt_authenticatable, {
    route: :session,
    strategy: true,
    controller: :sessions,
    model: 'devise/models/jwt_authenticatable'
})
