require 'devise_jwt/rails/routes'

module DeviseJwt
  class Engine < ::Rails::Engine
    isolate_namespace DeviseJwt
  end
end
