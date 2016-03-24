class DeviseJwt::RegistrationsController < DeviseJwtController
  def create
    self.resource = resource_class.new(sign_up_params)
    if resource.save
      sign_in(resource_name, self.resource)

      yield resource if block_given?

      render json: {status: :success, data: resource_data, auth_token: self.resource.jwt_token}, location: after_sign_up_path_for(resource), status: :created
    else
      render json: {status: :error, errors: resource_errors}, status: :unprocessable_entity
    end
  end

  def update
    super
  end

  def destroy
    self.resource.destroy
    sign_out(resource_name)
    yield self.resource if block_given?
    render json: {status: :success, message: I18n.t('devise.registrations.destroyed')}, location: after_sign_out_path_for(resource_name), status: :ok
  end
end

