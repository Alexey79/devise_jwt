require 'jwt'

module Devise
  module Models
    module JwtAuthenticatable
      extend ActiveSupport::Concern

      included do
        private :valid_expiration_time?
        private :encode
      end

      def valid_expiration_time?
        DeviseJwt::expiration_time.is_a?(ActiveSupport::Duration) && DeviseJwt::expiration_time > 0
      end

      def encode(pay_load)
        JWT.encode(pay_load, DeviseJwt.private_key, DeviseJwt.algorithm)
      end

      def generate_token
        pay_load = {sub: self.id, iss: self.to_json, iat: Time.now.to_i}
        pay_load[:exp] = DeviseJwt::expiration_time.from_now.to_i if valid_expiration_time?
        encode(pay_load)
      end

      module ClassMethods
      end
    end
  end
end
