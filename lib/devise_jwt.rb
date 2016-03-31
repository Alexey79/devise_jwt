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
    def private_key
      return rsa_key if rsa_encryption?
      return ec_key if ec_encryption?
      DeviseJwt.configuration.secret_key
    end

    def public_key
      return private_key.public_key if rsa_encryption? || ec_encryption?
      DeviseJwt.private_key
    end

    def algorithm
      DeviseJwt.configuration.algorithm.to_s.upcase
    end

    def expiration_time
      DeviseJwt.configuration.expiration_time
    end

    def rsa_encryption?
      !!(/RS\d{3}/ =~ algorithm)
    end

    def ec_encryption?
      !!(/ES\d{3}/ =~ algorithm)
    end

    private

    def secret_key_file
      return nil unless DeviseJwt.configuration.secret_key_path.present? && File.exist?(DeviseJwt.configuration.secret_key_path)
      File.open(DeviseJwt.configuration.secret_key_path)
    end

    def rsa_key
      OpenSSL::PKey::RSA.new(secret_key_file) if secret_key_file
    end

    def ec_key
      OpenSSL::PKey::EC.new(secret_key_file) if secret_key_file
    end
  end
end

Devise.add_module(:jwt_authenticatable, {
    route: :session,
    strategy: true,
    controller: :sessions,
    model: 'devise/models/jwt_authenticatable'
})
