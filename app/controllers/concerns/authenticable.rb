module Authenticable
  def current_user
    @current_user ||= User.find_by(auth_token: request.headers['Authorization'])
  end

  def authenticate_with_token!
    unauthorized_access unless user_logged_in?
  end

  def unauthorized_access
    render json: { errors: t('errors.messages.unauthorized_access') },
           status: :unauthorized
  end

  def user_logged_in?
    current_user.present?
  end
end
