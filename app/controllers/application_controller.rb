class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: %i[name city facebook twitter
                                               photo])
  end

  def after_sign_in_path_for(_resource)
    root_path
  end

  def user_admin?
    permission_denied unless current_user.admin
  end

  def permission_denied
    redirect_to root_path, alert: t('errors.messages.permission_denied')
  end
end
