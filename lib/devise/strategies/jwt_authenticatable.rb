require 'jwt'
require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class JwtAuthenticatable < Authenticatable
      def valid?
        valid_for_jwt_auth?
      end

      def authenticate!
        begin
          pay_load = decode(request.headers['Authorization'].split(' ').last)
          resource = mapping.to.find_by(id: pay_load.fetch('sub'))
          success! resource if validate(resource) { true }
        rescue JWT::ExpiredSignature
          fail(:expired_token)
        rescue
          fail(:invalid_token)
        end
      end

      def valid_for_jwt_auth?
        self.authentication_type = :jwt_auth
        request.headers['Authorization'].present?
      end

      private

      def decode(jwt)
        JWT.decode(jwt, DeviseJwt.secret).first
      end
    end
  end
end

Warden::Strategies.add(:jwt_authenticatable, Devise::Strategies::JwtAuthenticatable)
