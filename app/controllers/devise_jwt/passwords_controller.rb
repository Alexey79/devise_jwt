class DeviseJwt::PasswordsController < DeviseJwtController
  def create
    unless resource_params[:email].present?
      render json: {status: :error, errors: [{id: :email, message: I18n.t('devise_jwt.failure.missing_email')}]}, status: :unprocessable_entity
    end

    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield self.resource if block_given?

    if successfully_sent?(resource)
      render json: {status: :success, message: I18n.t('devise_jwt.passwords.sent')}, status: :ok
    else
      render json: {status: :error, errors: resource_errors}, status: :unprocessable_entity
    end
  end

  def update
    %i(password password_confirmation reset_password_token).each do |name|
      unless resource_params[name].present?
        return render json: {status: :error, errors: [{id: name, message: I18n.t("devise_jwt.failure.missing_#{name}")}]}, status: :unprocessable_entity
      end
    end

    self.resource = resource_class.reset_password_by_token(resource_params)
    yield self.resource if block_given?

    if resource.errors.empty?
      sign_in(resource_name, self.resource)
      render json: {status: :success, message: I18n.t('devise_jwt.passwords.updated')}, status: :ok
    else
      render json: {status: :error, errors: resource_errors}, status: :unprocessable_entity
    end
  end
end
