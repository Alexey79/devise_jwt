class DeviseJwt::SessionsController < DeviseJwtController
  prepend_before_action :require_no_authentication, only: [:create]
  prepend_before_action :allow_params_authentication!, only: :create
  prepend_before_action only: [:create, :destroy] { request.env['devise.skip_timeout'] = true }
  skip_before_filter :verify_signed_out_user, only: :destroy

  def create
    self.resource = warden.authenticate!(scope: resource_name)

    sign_in(resource_name, self.resource)
    yield resource if block_given?

    render json: {status: :success, data: resource_data, auth_token: self.resource.jwt_token}
  end

  def destroy
    signed_out = warden.authenticate!(scope: resource_name) && sign_out(resource_name)
    if signed_out
      yield if block_given?
      render json: {status: :success, message: I18n.t('devise_jwt.sessions.signed_out')}, status: :ok
    else
      render json: {status: :error, errors: [{messsage: I18n.t('devise_jwt.failure.invalid_token')}]}, status: :not_found
    end
  end
end

