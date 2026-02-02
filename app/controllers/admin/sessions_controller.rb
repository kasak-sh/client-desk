class Admin::SessionsController < ApplicationController
  layout 'admin'

  def new
  end

  def create
    user = User.find_by(email: params[:email]&.downcase)
    if user&.admin? && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to admin_accounts_path, notice: "Logged in successfully!"
    else
      flash.now[:alert] = "Invalid email or password, or you don't have admin access"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to admin_login_path, notice: "Logged out successfully!"
  end
end
