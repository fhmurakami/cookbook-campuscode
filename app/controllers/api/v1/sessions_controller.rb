class Api::V1::SessionsController < Api::V1::ApplicationController
  def create
    user = User.find_by(email: session_params[:email])

    if user&.valid_password?(session_params[:password])
      sign_in user, store: false
      user.generate_authentication_token!
      user.save
      render json: user, status: :ok
    else
      render json: { errors: t('devise.failure.invalid') },
             status: :unauthorized
    end
  end

  def destroy
    user = User.find_by(auth_token: params[:id])
    user.generate_authentication_token!
    user.save

    head :no_content
  end

  private

  def session_params
    params.require(:session).permit(%i[email password])
  end
end
