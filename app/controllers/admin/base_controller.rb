class Admin::BaseController < ApplicationController
  before_action :require_login
  before_action :require_admin

  layout 'admin'

  private

  def require_login
    unless logged_in?
      flash[:alert] = "You must be logged in to access this section"
      redirect_to admin_login_path
    end
  end
end
