require 'jwt'

module Devise
  module Models
    module JwtAuthenticatable
      extend ActiveSupport::Concern

      included do
        private :valid_expiration_time?
      end

      def valid_expiration_time?
        DeviseJwt::expiration_time.is_a?(ActiveSupport::Duration) && DeviseJwt::expiration_time > 0
      end

      def jwt_token
        pay_load = {sub: self.id, aud: self.to_json}
        pay_load[:exp] = DeviseJwt::expiration_time.from_now.to_i if valid_expiration_time?
        JWT.encode(pay_load, DeviseJwt.secret)
      end

      module ClassMethods
      end
    end
  end
end
