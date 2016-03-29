class DeviseJwt::RegistrationsController < DeviseJwtController
  prepend_before_action :require_no_authentication, only: [:create]
  prepend_before_action :authenticate_scope!, only: [:update, :destroy]

  def create
    self.resource = resource_class.new(sign_up_params)
    yield self.resource if block_given?

    if resource.save
      sign_in(resource_name, self.resource)

      render json: {status: :success, data: resource_data, auth_token: self.resource.jwt_token}, status: :created
    else
      render json: {status: :error, errors: resource_errors}, status: :unprocessable_entity
    end
  end

  def update
    resource_updated = self.resource.update_without_password(account_update_params)
    yield self.resource if block_given?

    if resource_updated
      render json: {status: :success, data: resource_data }, status: :ok
    else
      render json: {status: :error, errors: resource_errors}, status: :unprocessable_entity
    end
  end

  def destroy
    self.resource.destroy
    sign_out(resource_name)
    yield self.resource if block_given?
    render json: {status: :success}, status: :ok
  end

  private

  def sign_up_params
    devise_parameter_sanitizer.sanitize(:sign_up)
  end

  def account_update_params
    devise_parameter_sanitizer.sanitize(:account_update)
  end
end
