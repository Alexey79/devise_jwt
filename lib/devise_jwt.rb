# devise
require 'rails'
require 'devise'
require 'devise/models/jwt_authenticatable'
require 'devise/strategies/jwt_authenticatable'

# devise_jwt
require 'devise_jwt/engine'
require 'devise_jwt/config'
require 'devise_jwt/version'

module DeviseJwt
  autoload :JwtFailureApp,                'devise_jwt/jwt_failure_app'

  class << self
    def secret_key
      return DeviseJwt.configuration.secret_key unless DeviseJwt.configuration.secret_key_path.present? &&
                                                       File.exist?(DeviseJwt.configuration.secret_key_path)
      pem_file = File.open(DeviseJwt.configuration.secret_key_path)
      OpenSSL::PKey.read(pem_file) if !!(/(RS|ES)\d{3}/ =~ algorithm)
    end

    def algorithm
      DeviseJwt.configuration.algorithm.to_s.upcase
    end

    def expiration_time
      DeviseJwt.configuration.expiration_time
    end
  end
end

Devise.add_module(:jwt_authenticatable, {
    route: :session,
    strategy: true,
    controller: :sessions,
    model: 'devise/models/jwt_authenticatable'
})
