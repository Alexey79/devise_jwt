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
          resource = mapping.to.find_by_id(pay_load.fetch('sub'))
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
        private_key = DeviseJwt.secret_key
        public_key = private_key.respond_to?(:public_key) && private_key.public_key || private_key
        JWT.decode(jwt, public_key).first
      end
    end
  end
end

Warden::Strategies.add(:jwt_authenticatable, Devise::Strategies::JwtAuthenticatable)
