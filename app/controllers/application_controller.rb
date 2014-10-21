class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :exception
  before_action :take_current_host
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_permission_level

  protected

  def take_current_host
    # @current_host = "http://" + request.host
    if Rails.env.production?
      @current_host = "http://www.ragazzidel99.it"
    else
      @current_host = "http://localhost:3000"
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :user_name) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :password, :password_confirmation, :current_password, :user_name, :profile_image) }
  end

  def check_permission_level
    if user_signed_in?
      permission = User.where(id: current_user.id).take
      if permission.permission_level != 0
        sign_out
        # "redirect_to" documentation
        # http://apidock.com/rails/ActionController/Base/redirect_to
        redirect_to @current_host + "/acces_denied.html" # in public folder
      end
    end
  end
end

