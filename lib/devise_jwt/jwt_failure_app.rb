# coding: utf-8

require 'devise/failure_app'

module DeviseJwt
  class JwtFailureApp < Devise::FailureApp
    def http_auth
      self.status = respond_status
      self.content_type = request.format.to_s
      self.response_body = http_auth_body
    end

    def http_auth_body
      return i18n_message unless request_format
      method = "to_#{request_format}"
      if method == 'to_xml'
        { messsage: i18n_message }.to_xml(root: 'errors')
      elsif {}.respond_to?(method)
        {status: :error, errors: [{messsage: i18n_message}]}.send(method)
      else
        i18n_message
      end
    end

    private

    def respond_status
      case warden.message
        when :expired_token
          419
        else
          401
      end
    end
  end
end
