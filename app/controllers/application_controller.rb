class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_user, :logged_in?, :current_account

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def current_account
    @current_account ||= current_user&.account
  end

  def require_login
    unless logged_in?
      flash[:alert] = "You must be logged in to access this section"
      redirect_to root_path
    end
  end

  def require_active_account
    if current_account && !current_account.active?
      flash[:alert] = "Your account is inactive. Please contact support."
      session[:user_id] = nil
      redirect_to root_path
    end
  end

  def require_admin
    unless current_user&.admin?
      flash[:alert] = "You must be an admin to access this section"
      redirect_to dashboard_path
    end
  end

  def require_regular_user
    if current_user&.admin?
      flash[:alert] = "Admin users cannot access this section. Please use the admin interface."
      redirect_to admin_accounts_path
    end
  end
end
