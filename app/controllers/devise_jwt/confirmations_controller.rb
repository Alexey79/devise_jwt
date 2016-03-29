class DeviseJwt::ConfirmationsController < DeviseJwtController
  def create
    self.resource = resource_class.send_confirmation_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      render json: {status: :success, message: I18n.t('devise_jwt.confirmations.sent')}, status: :ok
    else
      render json: {status: :error, errors: resource_errors}, status: :unprocessable_entity
    end
  end

  def show
    unless resource_params[:confirmation_token].present?
      render json: {status: :error, errors: [{id: :confirmation_token, message: I18n.t('devise_jwt.confirmations.missing_confirmation_token')}]}, status: :unprocessable_entity
    end

    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?
      render json: {status: :success, message: I18n.t('devise_jwt.confirmations.confirmed')}, status: :ok
    else
      render json: {status: :error, errors: resource_errors}, status: :unprocessable_entity
    end
  end
end